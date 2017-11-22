require 'charyf'
require 'charyf/engine/intent/processors/adapt/routing_builder'

require 'pycall/import'

module Charyf
  module Engine
    class Intent
      module Processors
        class Adapt < Base

          processor_name :adapt
          definition_extension :adapt

          MUTEX = Mutex.new.freeze
          private_constant :MUTEX

          class << self
            include PyCall::Import

            def engine(skill = nil)
              MUTEX.synchronize {
                return _engines[skill] ||= init_engine(skill)
              }
            end

            def init_engine(skill = nil)
              pyfrom 'adapt.intent', import: :IntentBuilder
              pyfrom 'adapt.engine', import: :IntentDeterminationEngine

              IntentDeterminationEngine.new
            end

            def public_routing_for(skill_name)
              # TODO We need to assign uniq names with skill in the probably
              # TODO We need to keep database of all routes
              builder = RoutingBuilder.new(skill_name)

              yield builder

              intents = builder.build(engine)

              # TODO handle already existing
              intents.each do |intent|
                _intents[intent.name] = intent
              end
            end

            def private_routing_for(skill_name)

            end

            def _engines
              @engines ||= {}
            end

            def _intents
              @intents ||= {}
            end

          end

          def determine(request, skill = nil)
            text = request.text

            adapt_intent = nil
            generator = self.class.engine(skill).determine_intent(text)
            begin
              adapt_intent = PyCall.builtins.next(generator)
            rescue PyCall::PyError
              # ignored
            end

            return unknown unless adapt_intent

            confidence = adapt_intent['confidence']
            app_intent = self.class._intents[adapt_intent['intent_type']]


            matches =  app_intent.entities.map { |e| e.keys.first }.inject({}) do |h, entity|
              h[Adapt.unscope_name(app_intent.skill, entity)] = adapt_intent[entity]
              h
            end

            # def initialize(skill, controller, action, confidence, matches = Hash.new)
            Charyf::Engine::Intent.new(app_intent.skill, app_intent.controller, app_intent.action, confidence, matches)
          end

        end
      end
    end
  end
end

# Create alias for prettier use
AdaptIntentProcessor = Charyf::Engine::Intent::Processors::Adapt