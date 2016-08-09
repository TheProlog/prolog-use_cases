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
  spec.description   = %Q(Following a hexagonal or clean architecture, the use cases are implemented in the next major layer "outward" from the core entities, which are known to this code but not vice versa.)
  spec.homepage      = "https://github.com/theprolog/prolog-use_cases"
  spec.required_ruby_version = '>= 2.3.0'

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
  spec.add_dependency "prolog-services-markdown_to_html", "~> 1.0", ">= 1.0.2"
  spec.add_dependency "prolog-services-replace_content", "0.1.2"
  spec.add_dependency "prolog-use_cases-publish_new_article", "~> 0.2", ">= 0.2.2"
  spec.add_dependency "prolog-use_cases-register_new_member", "~> 0.1", ">= 0.1.1"

  spec.add_dependency "activemodel", "~> 4.2", ">= 4.2.5"
  spec.add_dependency "validates_email_format_of", "~> 1.6", ">= 1.6.3"
  spec.add_dependency "ox", "~> 2.3"
  spec.add_dependency "html-pipeline", "~> 2.3"
  spec.add_dependency "gemoji", "~> 2.1"
  spec.add_dependency "github-markdown", "0.6.9"
  spec.add_dependency "rinku", "~> 2.0", ">= 2.0.0"
  spec.add_dependency "uuid", "~> 2.3", ">= 2.3.8"

  spec.add_dependency "dry-validation", "~> 0.9", ">= 0.9.3"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 11.0" # NOTE: was "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_development_dependency "minitest-matchers", "~> 1.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.0"
  spec.add_development_dependency "minitest-tagz", "~> 1.2"

  spec.add_development_dependency "ffaker", "~> 2.2"
  spec.add_development_dependency "flay", "~> 2.6"
  spec.add_development_dependency "flog", "~> 4.3", ">= 4.3.2"
  spec.add_development_dependency "reek", "~> 4.0"
  spec.add_development_dependency "rubocop", "~> 0.39"
  spec.add_development_dependency "simplecov", "~> 0.10"
  spec.add_development_dependency "pry-byebug", "~> 3.2"
  spec.add_development_dependency "pry-doc", "~> 0.8"
  spec.add_development_dependency "colorize", "~> 0.7", ">= 0.7.7"
  spec.add_development_dependency "awesome_print", "~> 1.6", ">= 1.6.1"
end
