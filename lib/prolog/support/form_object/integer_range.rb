# frozen_string_literal: true

require 'virtus'

module Prolog
  module Support
    module FormObject
      # Coerces an attribute to a range of integers. Will be transparent for
      # range of integers. Range of strings with integer values ('42') will be
      # converted to intended values. Value as a single integer-convertible
      # value will be treated as a range of (0..value.to_i). Anything else
      # will produce an (invalid in our use here) range of (-1..-1).
      # Reek thinks every method here smells of :reek:UtilityFunction. Virtus
      # uses a frozen instance of this class; state is unmodifiable.
      class IntegerRange < Virtus::Attribute
        def coerce(value)
          ensure_valid_value_type(value) do
            ensure_both_endpoints_specified(value) { range_from_value(value) }
          end
        end

        private

        def begin_value_for(value)
          value.begin.to_i
        end

        def end_value_for(value)
          value.end.to_i
        end

        def ensure_valid_value_type(value)
          return (-1..-1) unless value.is_a?(Range) || value.to_i.nonzero?
          yield
        end

        def ensure_both_endpoints_specified(value)
          return (0..value.to_i) unless value.is_a? Range
          yield
        end

        def range_from_value(value)
          Range.new(begin_value_for(value), end_value_for(value))
        end
      end # class Prolog::Support::FormObject::IntegerRange
    end
  end
end
