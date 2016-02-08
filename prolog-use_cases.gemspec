# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prolog/use_cases/version'

Gem::Specification.new do |spec|
  spec.name          = "prolog-use_cases"
  spec.version       = Prolog::UseCases::VERSION
  spec.authors       = ["Jeff Dickey"]
  spec.email         = ["jdickey@seven-sigma.com"]
  spec.license       = 'Nonstandard'
  spec.summary       = %q{Use-case layer for Meldd/Prolog application.}
  spec_description   = <<~EOT
                       Following a hexagonal or clean architecture, the use cases are implemented
                       in the next major layer "outward" from the core entities, which are known
                       to this code but not vice versa.
                       EOT
  spec.description   = spec_description.split.join ' '
  spec.homepage      = "https://github.com/theprolog/prolog-use_cases"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://jdickey@git.fury.io/jdickey/"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "prolog_core", "~> 0.4"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_development_dependency "minitest-matchers", "~> 1.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.0"
  spec.add_development_dependency "minitest-tagz", "~> 1.2"

  spec.add_development_dependency "ffaker", "~> 2.2"
  spec.add_development_dependency "flay", "~> 2.6"
  spec.add_development_dependency "flog", "~> 4.3", ">= 4.3.2"
  spec.add_development_dependency "reek", "~> 3.7"
  spec.add_development_dependency "rubocop", "0.35.1" # FIXME: newer introduces odd config problems
  spec.add_development_dependency "simplecov", "~> 0.10"
  spec.add_development_dependency "pry-byebug", "~> 3.2"
  spec.add_development_dependency "pry-doc", "~> 0.8"
end
