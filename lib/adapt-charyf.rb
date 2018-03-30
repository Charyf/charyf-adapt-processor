require 'charyf'
require_relative 'adapt/processor'

module Adapt
  class Extension < Charyf::Extension

    generators do
      require_relative 'adapt/generators/intent/intent_generator'
    end

    config.generators.skill_hooks :intents, :adapt => true

  end

  extend self

  def lookup_paths
    @lookup_paths ||= []
  end

end