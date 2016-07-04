# frozen_string_literal: true

require_relative './asserters/assert_requires_initialize_parameter'

module MiniTest
  # Adding custom assertions to make specs easier to read
  module Assertions
    def assert_requires_initialize_parameter(klass, full_params, param_key,
                                             message = nil)
      AssertRequiresInitializeParameter.new(klass, full_params, param_key,
                                            message).call(method(:assert))
    end
  end

  # Make it available to MiniTest::Spec
  module Expectations
    infect_an_assertion :assert_requires_initialize_parameter,
                        :must_require_initialize_parameter, :reverse
  end
end
