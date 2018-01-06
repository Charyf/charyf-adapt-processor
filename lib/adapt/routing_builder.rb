module Adapt
  class RoutingBuilder

    class InvalidState < StandardError; end

    class Intent
      attr_reader :skill_name, :name, :controller, :action, :entities

      def initialize(skill_name, name)
        @skill_name = skill_name
        @name = name
        @controller = nil
        @action = nil

        @entities = []
      end

      def required(entity)
        entity = Adapt.scoped_name(@skill_name, entity)
        @entities << {entity => :required}

        return self
      end

      def optional(entity)
        entity = Adapt.scoped_name(@skill_name, entity)
        @entities << {entity => :optional}

        return self
      end

      def route_to(controller, action)
        @controller = controller
        @action = action
      end
    end # End of Intent.class

    def initialize(skill_name)
      @skill_name = skill_name

      @keywords = {}
      @regexps = []
      @intents = []
    end

    def register_keywords(category, word, *words)
      words = [word] + words

      (@keywords[Adapt.scoped_name(@skill_name, category)] ||= []).push(words).flatten!
    end

    def register_regex(regex)
      @regexps << scope_regex(regex)

    end

    def intent(name)
      intent = Intent.new(@skill_name, Adapt.scoped_name(@skill_name,name.to_s.gsub(' ', '')))
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
      regex.to_s.gsub(/\(\?P\<(.*)\>/, "(?P<#{Adapt.scoped_name(@skill_name, '\1').gsub('.', '_')}>")
    end

  end
end
