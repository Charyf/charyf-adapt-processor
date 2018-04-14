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
    config.lookup_paths = []

  end

  extend self

  def locale
    config.locale || I18n.locale
  end

  def config
    Extension.config
  end

end