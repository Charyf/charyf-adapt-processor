require 'charyf/utils/generators/named_base'

module Adapt
  module Generators
    class IntentGenerator < Charyf::Generators::NamedBase

      def something
        require 'pry'
        binding.pry
      end

    end
  end
end
