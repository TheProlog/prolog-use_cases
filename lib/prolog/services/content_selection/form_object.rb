
require 'active_model'
require 'virtus'

require 'prolog/core'

module Prolog
  module Services
    # Encapsulates logic for extracting a section of content from an Article
    # body.
    class ContentSelection
      # Cources an attribute to a range of integers. Will be transparent for
      # range of integers. Range of strings with integer values ('42') will be
      # converted to intended values. Value as a single integer-convertible
      # value will be treated as a range of (0..value.to_i). Anything else will
      # produce an (invalid in our use here) range of (-1..-1).
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
      end

      # Form object for data validation and organisation
      class FormObject
        include Virtus.model
        include ActiveModel::Validations

        attribute :article, Prolog::Core::Article
        attribute :last_contribution_id, Integer
        attribute :endpoints, IntegerRange

        validate :article?
        validate :validate_endpoints
        validate :validate_last_contribution_id

        def selected_markup
          return '' unless valid?
          article.body[endpoints]
        end

        private

        def article?
          return true if article.instance_of?(Prolog::Core::Article)
          errors.add :article, 'invalid'
          false
        end

        def coverage
          bl_range = (0..article&.body&.length.to_i)
          endpoints.grep bl_range
        end

        def valid_endpoints?
          coverage == endpoints.to_a
        end

        def validate_endpoints
          return true if valid_endpoints?
          errors.add :endpoints, 'invalid'
          false
        end

        def validate_last_contribution_id
          return true if last_contribution_id
          errors.add :last_contribution_id, 'missing'
          false
        end
      end # class Prolog::Services::ContentSelection::FormObject
    end # class Prolog::Services::ContentSelection
  end
end
