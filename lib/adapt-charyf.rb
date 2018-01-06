require 'charyf'
require_relative 'adapt/adapt'

module Adapt
  class Extension < Charyf::Extension

    generators do
      require_relative 'adapt/generators/intent/intent_generator'
    end

    config.generators.skill_hooks :intents, :adapt => true

  end
end