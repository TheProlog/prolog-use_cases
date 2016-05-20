# frozen_string_literal: true

module MiniTest
  # Adding custom assertions to make specs easier to read
  module Assertions
    def _error_from_arwmp_call(blk, error_class)
      error = nil
      begin
        blk.call
      rescue error_class => error_received
        error = error_received
      end
      error
    end

    def assert_raise_with_message_part(blk, error_message_expr,
                                       error_class = ArgumentError,
                                       message = nil)
      message ||= "expected #{blk}\nto raise #{error_class.name} with " \
        "message matching #{error_message_expr}"
      error = _error_from_arwmp_call(blk, error_class)
      assert error&.message.to_s.match(error_message_expr), message
    end
  end

  # Make it available to MiniTest::Spec
  module Expectations
    infect_an_assertion :assert_raise_with_message_part,
                        :must_raise_with_message_part, :reverse
  end
end
