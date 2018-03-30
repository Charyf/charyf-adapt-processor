module Adapt
  class RoutingBuilder

    class InvalidState < StandardError; end

    class Intent
      attr_reader :name, :entities

      def initialize(name)
        @name = name

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

    end # End of Intent.class

    def initialize
      @keywords = {}
      @regexps = []
      @intents = []
    end

    def register_keywords(category, word, *words)
      words = [word] + words

      (@keywords[category] ||= []).push(words).flatten!
    end

    def register_regex(regex)
      @regexps << regex
    end

    def intent(name)
      intent = Intent.new(name)
      @intents << intent

      intent
    end

    def build(engine, python_builder)
      @keywords.each do |group, words|
        words.each do |word|
          engine.register_entity(word, group)
        end
      end

      @regexps.each do |regexp|
        engine.register_regex_entity(regexp)
      end

      @intents.each do |intent|
        builder = python_builder.new(intent.name)

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

  end
end
