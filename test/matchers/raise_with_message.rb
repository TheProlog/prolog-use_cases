# frozen_string_literal: true

module MiniTest
  # Adding custom assertions to make specs easier to read
  module Assertions
    def _error_from_arwm_call(blk, error_class)
      error = nil
      begin
        blk.call
      rescue error_class => error_received
        error = error_received
      end
      error
    end

    def assert_raise_with_message(blk, error_message,
                                  error_class = ArgumentError,
                                  message = nil)
      message ||= "expected #{blk}\nto raise #{error_class.name} with " \
        "message '#{error_message}'"
      error = _error_from_arwm_call(blk, error_class)
      assert error&.message == error_message, message
    end
  end

  # Make it available to MiniTest::Spec
  module Expectations
    infect_an_assertion :assert_raise_with_message, :must_raise_with_message,
                        :reverse
  end
end
