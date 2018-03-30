require 'charyf/utils/generators/named_base'

module Adapt
  module Generators
    class IntentGenerator < Charyf::Generators::NamedBase

      source_root File.expand_path('templates', __dir__)

      def public_routing
        template 'intents/adapt/routing.adapt.rb', File.join('app/skills', skill_content_path, 'intents', 'adapt', 'default_routing.adapt.rb')
      end

    end
  end
end
