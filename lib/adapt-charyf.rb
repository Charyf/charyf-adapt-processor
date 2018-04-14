require 'charyf'
require 'i18n'

require_relative 'adapt/processor'

module Adapt
  class Extension < Charyf::Extension

    generators do
      require_relative 'adapt/generators/intent/intent_generator'
      require_relative 'adapt/generators/install/install_generator'
    end

    config.generators.skill_hooks :intents, :adapt => true

    # If unset, I18n locale will be used
    config.locale = nil

  end

  extend self

  def lookup_paths
    @lookup_paths ||= []
  end

  def locale
    Extension.config.locale || I18n.locale
  end

end