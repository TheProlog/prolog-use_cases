# frozen_string_literal: true

module MiniTest
  # Adding custom assertions to make specs easier to read
  module Assertions
    def assert_success_with_no_errors(blk, message = nil)
      message ||= "expected #{blk}\nto be successful and have no errors"
      call_result = blk.call
      # call_result = obj.call author_name: author_name
      passing = call_result.success? && call_result.errors.empty?
      assert passing, message
    end
  end

  # Make it available to MiniTest::Spec
  module Expectations
    infect_an_assertion :assert_success_with_no_errors,
                        :must_be_success_with_no_errors, :reverse
  end
end
