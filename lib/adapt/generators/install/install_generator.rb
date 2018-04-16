require 'charyf/utils/generator/base'

module Adapt
  module Generators
    class InstallGenerator < Charyf::Generators::Base

      source_root File.expand_path('templates', __dir__)

      def initializer
        template 'config/initializers/adapt.rb.tt'
      end

      def finalize
        return if behavior != :invoke || options[:autorun]

        say_status 'notice', "Adapt installed" +
            "\n\t\tDo not forget to set adapt intent processor in application configuration" +
            "\n\t\t\tconfig.enabled_intent_processors = [.., :adapt, ..]", :green
      end

    end
  end
end
