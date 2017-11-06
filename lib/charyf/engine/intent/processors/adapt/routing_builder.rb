require 'charyf/engine/intent/processors/adapt'

module Charyf
  module Engine
    class Intent
      module Processors
        class Adapt < Base
          class RoutingBuilder

            class InvalidState < StandardError; end

            class Intent
              attr_reader :skill, :name, :controller, :action, :entities

              def initialize(skill, name)
                @skill = skill
                @name = name
                @controller = nil
                @action = nil

                @entities = []
              end

              def required(entity)
                entity = Adapt.scoped_name(@skill, entity)
                @entities << {entity => :required}

                return self
              end

              def optional(entity)
                entity = Adapt.scoped_name(@skill, entity)
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
              intent = Intent.new(@skill, Adapt.scoped_name(@skill,name.to_s.gsub(' ', '')))
              @intents << intent

              intent
            end

            def build(engine)
              @keywords.each do |group, words|
                words.each do |word|
                  engine.register_entity(word, group)
                end
              end

              @regexps.each do |regexp|
                engine.register_regex_entity(regexp)
              end

              @intents.each do |intent|
                builder = IntentBuilder.new(intent.name)

                intent.entities.each do |entity|
                  entity, method = entity.first
                  case method
                    when :required
                      builder.require(entity)
                    when :optional
                      builder.optionally(entity)
                    else
                      raise InvalidState.new('You should never end up here')
                  end

                  adapt_intent = builder.build
                  engine.register_intent_parser(adapt_intent)
                end
              end

              @intents
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
