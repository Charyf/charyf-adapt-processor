require 'charyf'
require 'charyf/engine/intent/processors/adapt/routing_builder'

require 'pycall/import'

module Charyf
  module Engine
    class Intent
      module Processors
        class Adapt < Base

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

              @engine = IntentDeterminationEngine.new
            end

            def public_routing_for(skill_name)
              # TODO We need to assign uniq names with skill in the probably
              # TODO We need to keep database of all routes
              builder = RoutingBuilder.new(skill_name)

              yield builder

              builder.build(engine)
            end

            def private_routing_for(skill_name)

            end

            def _engines
              @engines ||= {}
            end

          end

          def determine(request, skill = nil)
            unknown
          end

        end
      end
    end
  end
end

# Create alias for prettier use
AdaptIntentProcessor = Charyf::Engine::Intent::Processors::Adapt