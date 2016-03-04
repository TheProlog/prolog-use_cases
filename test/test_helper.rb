$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# require 'prolog_core'
#
# require_relative 'support/ui_error_spy.rb'

# test/test_helper.rb
#
# Sets up the supporting environment for testing our code using SimpleCov,
# Capybara, and others.
#
# ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### #
#                         SECTION 1 OF 3: Preamble.                            #
#
require 'pry-byebug'

# ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### #
#                     SECTION 2 OF 3: Coverage analysis.                       #
#
# Load SimpleCov. Also load CodeClimate test reporter if and only if a
# `CODECLIMATE_REPO_TOKEN` environment variable is set.

require 'simplecov'
require 'minitest/spec'
require 'minitest/autorun'
require 'awesome_print'

uses_cova = ENV['COVERALLS_REPO_TOKEN']
uses_cc = ENV['CODECLIMATE_REPO_TOKEN']

if uses_cc
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

SimpleCov.start do
  sc_formatters = [
    SimpleCov::Formatter::HTMLFormatter
  ]

  if uses_cova
    require 'coveralls'
    sc_formatters.unshift(Coveralls::SimpleCov::Formatter)
  end

  sc_formatters.unshift(CodeClimate::TestReporter::Formatter) if uses_cc
  self.formatters = sc_formatters
  # formatter SimpleCov::Formatter::MultiFormatter[*sc_formatters]
  Coveralls.wear! if uses_cova
end

# if uses_cc
#   CodeClimate.TestReporter.start
# end

# ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### #
#                SECTION 3 OF 3: Unconditional MiniTest setup.                 #
#
require 'minitest/autorun' # harmless if already required
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(
  color: true, detailed_skip: true, fast_fail: true)]

require 'minitest/tagz'
tags = ENV['TAGS'].split(',') if ENV['TAGS']
tags ||= []
tags << 'focus'
Minitest::Tagz.choose_tags(*tags, run_all_if_no_match: true)
