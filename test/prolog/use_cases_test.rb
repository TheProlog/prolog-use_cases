
require 'test_helper'

require 'prolog/use_cases' # needed when running as single test file

module Prolog
  # Reformatted, as-generated test for version string.
  class UseCasesTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Prolog::UseCases::VERSION
    end

    # def test_it_does_something_useful
    #   assert false
    # end
  end
end
