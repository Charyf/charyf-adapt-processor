require 'charyf/utils/generators/named_base'

module Adapt
  module Generators
    class IntentGenerator < Charyf::Generators::NamedBase

      source_root File.expand_path('templates', __dir__)

      def public_routing
        template 'intents/adapt_public.rb', File.join('app/skills', skill_content_path, 'intents', 'adapt_public.rb')
      end

      def private_routing
        template 'intents/adapt_private.rb', File.join('app/skills', skill_content_path, 'intents', 'adapt_private.rb')
      end

    end
  end
end
