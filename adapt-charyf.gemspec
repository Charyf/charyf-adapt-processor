# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adapt/version'

Gem::Specification.new do |spec|
  spec.name          = "adapt-charyf"
  spec.version       = Adapt::VERSION
  spec.authors       = ["Richard Ludvigh"]
  spec.email         = ["richard.ludvigh@gmail.com"]

  spec.summary       = 'Charyf intent processor wrapper for MycroftAI/adapt library'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/Charyf/charyf-adapt-processor'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "charyf", "~> 0"
  spec.add_runtime_dependency "pycall", "~> 1.0.3"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.post_install_message = <<-EOM
Make sure MycroftAI/adapt python library is installed [https://github.com/MycroftAI/adapt].
Also set the ENV[PYTHON] variable to python executable with the library installed.

Read -> Speak -> Chat!
  EOM
end