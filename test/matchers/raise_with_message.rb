# frozen_string_literal: true

module MiniTest
  # Adding custom assertions to make specs easier to read
  module Assertions
    module ARWM
      def self.error_from_call(blk, error_class)
        error = nil
        begin
          blk.call
        rescue error_class => error_received
          error = error_received
        end
        error
      end

      def self.error_matches?(error, error_class, error_message)
        return false unless error.is_a?(error_class)
        error&.message == error_message
      end
    end

    def assert_raise_with_message(blk, error_message,
                                  error_class = ArgumentError,
                                  message = nil)
      message ||= "expected #{blk}\nto raise #{error_class.name} with " \
        "message '#{error_message}'"
      error = ARWM.error_from_call(blk, error_class)
      is_match = ARWM.error_matches?(error, error_class, error_message)
      assert is_match, message
    end
  end

  # Make it available to MiniTest::Spec
  module Expectations
    infect_an_assertion :assert_raise_with_message, :must_raise_with_message,
                        :reverse
  end
end
