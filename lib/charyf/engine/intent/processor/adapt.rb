require 'charyf'
require 'charyf/engine/intent/processor/adapt/routing_builder'

require 'pycall/import'

module Charyf
  module Engine
    class Intent
      module Processor
        class Adapt < Base

          strategy_name :adapt

          MUTEX = Mutex.new.freeze
          private_constant :MUTEX

          class << self
            include PyCall::Import

            def get_for(skill_name = nil)
              engine = engine(skill_name)

              self.new(skill_name, engine)
            end

            def engine(skill_name = nil)
              MUTEX.synchronize {
                return _engines[skill_name] ||= init_engine
              }
            end

            def init_engine
              unless @_python_loaded
                pyfrom 'adapt.intent', import: :IntentBuilder
                pyfrom 'adapt.engine', import: :IntentDeterminationEngine
                @_python_loaded = true
              end

              IntentDeterminationEngine.new
            end

            def _engines
              @engines ||= {}
            end

            def _intents
              @intents ||= {}
            end

          end

          def initialize(skill_name, engine)
            @skill_name = skill_name
            @engine = engine
          end

          def load(skill_name, block)
            builder = Adapt::RoutingBuilder.new(skill_name)

            block.call(builder)

            intents = builder.build(@engine)

            # TODO handle already existing
            intents.each do |intent|
              self.class._intents[intent.name] = intent
            end
          end

          def determine(request)
            adapt_intent = nil
            text = Charyf.application.parser.normalize(request.text)
            generator = @engine.determine_intent(text)
            begin
              adapt_intent = PyCall.builtins.next(generator)
            rescue PyCall::PyError
              # ignored
            end

            return unknown unless adapt_intent

            confidence = adapt_intent['confidence']
            app_intent = self.class._intents[adapt_intent['intent_type']]


            matches =  app_intent.entities.map { |e| e.keys.first }.inject({}) do |h, entity|
              h[Adapt.unscope_name(app_intent.skill_name, entity)] = adapt_intent[entity]
              h
            end

            Charyf::Engine::Intent.new(app_intent.skill_name, app_intent.controller, app_intent.action, confidence, matches)
          end

        end
      end
    end
  end
end
