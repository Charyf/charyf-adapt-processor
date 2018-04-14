require 'charyf/utils/strategy/base_class'
require 'charyf/utils/strategy/owner_class'

module Adapt
  module Helpers
    module Parser

      extend Charyf::Strategy::OwnerClass

      class Base

        include Charyf::Strategy::BaseClass

        def self.normalize(text, remove_articles: true)
          raise Charyf::Utils::NotImplemented.new
        end

      end # End of base

      def self.get(language)
        list[language]
      end

    end
  end
end

require_relative 'en_parser'