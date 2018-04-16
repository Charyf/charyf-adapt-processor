require 'charyf'
require 'i18n'

require_relative 'adapt/processor'

module Adapt
  class Extension < Charyf::Extension

    # Load generators inside this block
    generators do
      require_relative 'adapt/generators/intent/intent_generator'
      require_relative 'adapt/generators/install/install_generator'
    end

    # Add generator hooks
    #
    # Skill hook is run when new skill is being generated
    #
    config.generators.skill_hooks << 'adapt:intent'
    #
    # Installers are automatically run if this gem is present during generation of new application
    #
    config.generators.installers << 'adapt:install'

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