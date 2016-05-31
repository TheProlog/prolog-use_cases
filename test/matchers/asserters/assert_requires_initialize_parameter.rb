# frozen_string_literal: true

module MiniTest
  # Adding custom assertions to make specs easier to read
  module Assertions
    # Actual test logic for `#assert_requires_initialize_parameter`.
    class AssertRequiresInitializeParameter
      def initialize(klass, full_params, param_key, message)
        @klass = klass
        @full_params = full_params
        @param_key = param_key
        @message = initial_message_from(message, param_key)
        self
      end

      def call(assert)
        assert.call(errors_as_expected(save_and_try_to_init), message)
      end

      private

      attr_reader :full_params, :klass, :message, :param_key

      def errors_as_expected(errors)
        if errors[:unexpected]
          @message += " unexpected error: #{errors[:unexpected]}"
        end
        errors[:expected] && !errors[:unexpected]
      end

      def initial_message_from(message, param_key)
        message || "expected to require parameter value for #{param_key}"
      end

      def save_and_try_to_init
        saved_item = full_params[param_key]
        full_params.delete param_key
        errors = try_to_init
        full_params[param_key] = saved_item
        errors
      end

      def try_to_init
        unexpected_error = nil
        expected_error = nil
        begin
          _ = klass.new full_params
        rescue ArgumentError => error
          expected_error = error
        rescue RuntimeError => error
          unexpected_error = error
        end
        { expected: expected_error, unexpected: unexpected_error }
      end
    end # class MiniTest::Assertions::AssertRequiresInitializeParameter
  end
end
