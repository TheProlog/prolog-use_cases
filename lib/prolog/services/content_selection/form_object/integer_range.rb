
require 'virtus'

module Prolog
  module Services
    # Encapsulates logic for extracting a section of content from an Article
    # body.
    class ContentSelection
      # Form object for data validation and organisation
      class FormObject
        # Cources an attribute to a range of integers. Will be transparent for
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

          def ensure_valid_value_type(value)
            return (-1..-1) unless value.is_a?(Range) || value.to_i != 0
            yield
          end

          def ensure_both_endpoints_specified(value)
            return (0..value.to_i) unless value.is_a? Range
            yield
          end

          def range_from_value(value)
            Range.new(value.begin.to_i, value.end.to_i)
          end
        end # class Prolog::Services::ContentSelection::FormObject::IntegerRange
      end # class Prolog::Services::ContentSelection::FormObject
    end # class Prolog::Services::ContentSelection
  end
end
