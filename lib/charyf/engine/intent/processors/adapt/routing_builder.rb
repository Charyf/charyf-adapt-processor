require 'charyf/engine/intent/processors/adapt'

module Charyf
  module Engine
    class Intent
      module Processors
        class Adapt < Base
          class RoutingBuilder

            class Intent
              def initialize(name)
                @name = name.to_s.gsub(' ', '_').camelize
                @controller = nil
                @action = nil

                @entities = []
              end

              def required(entity)
                @entities << {entity => :required}

                return self
              end

              def optional(entity)
                @entities << {entity => :optional}

                return self
              end

              def route_to(controller, action)
                @controller = controller
                @action = action
              end
            end

            def initialize(skill)
              @skill = skill

              @keywords = {}
              @regexps = []
              @intents = []
            end

            def register_keywords(category, word, *words)
              words = [word] + words

              (@keywords[Adapt.scoped_name(@skill, category)] ||= []).push(words).flatten!
            end

            def register_regex(regex)
              @regexps << scope_regex(regex)

            end

            def intent(name)
              intent = Intent.new(name)
              @intents << intent

              intent
            end

            def build(engine)
              binding.pry

              # words.each do |word|
              #   @engine.register_entity(word, Adapt.scoped_name(@skill, category))
              # end

              # @engine.register_regex_entity(scope_regex(regex))
            end

            private

            def scope_regex(regex)
              regex.to_s.gsub(/\(\?P\<(.*)\>/, "(?P<#{Adapt.scoped_name(@skill, '\1').gsub('.', '_')}>")
            end

          end
        end
      end
    end
  end
end
