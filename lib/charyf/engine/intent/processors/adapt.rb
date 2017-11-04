module Charyf
  module Engine
    class Intent
      module Processors
        class Adapt < Base

          class << self
            @semaphore = Mutex.new

            def engine
              @engine ||= init_engine
            end

            def init_engine


              @engine = engine
            end
          end

          def process(request, conversation_id, skill = nil)

            #TODO remove
            if request.text =~ /foo/
              return Charyf::Engine::Intent.new(:Example, :foo_bar, :foo, 100)
            end
            if request.text =~ /bar/
              return Charyf::Engine::Intent.new(:Example, :foo_bar, :bar, 100)
            end
            # TODO TILL HERE


            unknown
          end

        end
      end
    end
  end
end
