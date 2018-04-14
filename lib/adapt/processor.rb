require 'pycall/import'

require_relative 'routing_builder'
require_relative 'helpers/parser'

module Adapt
  module Intent
    class Processor < Charyf::Engine::Intent::Processor::Base

      class NameCollisionError < StandardError; end

      strategy_name :adapt

      class << self
        include PyCall::Import

        def engine
          unless @_python_loaded
            self.pyfrom 'adapt.intent', import: :IntentBuilder
            self.pyfrom 'adapt.engine', import: :IntentDeterminationEngine
            @_python_loaded = true
          end

          @_engine ||= IntentDeterminationEngine.new
        end

        def _intents
          @_intents ||= {}
        end

        def setup
          return if @_initialized
          @_initialized = true

          load_files
        end

        def parser
          return @_parser if @_parser_initialized

          @_parser = Adapt::Helpers::Parser.get(Adapt.config.locale)
          @_parser_initialized = true
          puts "No language helper for locale '#{Adapt.config.locale}' available" if @_parser.nil?
        end

        private

        def load_files
          # Seek skill folders
          Charyf::Skill.list.each do |skill_klass|
            root = skill_klass.skill_root

            Dir[root.join('intents', '**', '*.adapt.rb')].each do |intent_definition_file|
              require intent_definition_file
            end
          end

          # Load additional paths
          Adapt.config.lookup_paths.flatten.each do |path|
            Dir[Pathname.new(path.to_s).join('**', '*.adapt.rb')].each do |intent_definition_file|
              require intent_definition_file
            end
          end

        end
      end

      def initialize
        self.class.setup
        @engine = self.class.engine

        @parser = self.class.parser
      end

      def define(&block)
        builder = Adapt::RoutingBuilder.new

        block.call(builder)

        intents = builder.build(@engine, IntentBuilder)

        intents.each do |intent|
          # TODO handle already existing
          raise NameCollisionError.new("Intent name '#{intent.name}' already in use.") if self.class._intents[intent.name]

          self.class._intents[intent.name] = intent
        end
      end

      def determine(request)
        adapt_intent = nil

        # Normalize text
        text = @parser ? @parser.normalize(request.text) : request.text

        generator = @engine.determine_intent(text)
        begin
          adapt_intent = PyCall.builtins.next(generator)
        rescue PyCall::PyError
          # ignored
        end

        return unknown unless adapt_intent

        confidence = adapt_intent['confidence']
        app_intent = self.class._intents[adapt_intent['intent_type']]


        entities = app_intent.entities.map { |e| e.keys.first }.inject({}) do |h, entity|
          h[entity] = {
              value: adapt_intent[entity]
          }

          h
        end

        return Charyf::Engine::Intent.new(app_intent.name, confidence, entities)
      end

    end
  end
end
