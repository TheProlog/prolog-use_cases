
require 'active_model'
require 'virtus'

require 'prolog/support/form_object/integer_range'

module Prolog
  module UseCases
    # Validate selection parameters for eventual Contribution proposal.
    class ValidateSelection
      # Form object for data validation and organisation
      class FormObject
        include Virtus.value_object
        include ActiveModel::Validations
        include Prolog::Support::FormObject

        values do
          attribute :article, Object
          attribute :endpoints, IntegerRange
        end

        ATTR_REQUIRED = '%{value} is required.'
        validates_presence_of :article, message: ATTR_REQUIRED
        validate :endpoints_supplied
        validate :endpoints_within_article_body

        private

        def endpoints_supplied
          return true unless endpoints == (-1..-1)
          errors.add :endpoints, 'must be specified.'
        end

        def end_endpoint_less_than_length?
          length = article&.body&.length.to_i
          endpoints.end <= length
        end

        def endpoints_within_article_body
          return true if end_endpoint_less_than_length?
          errors.add :endpoints, 'must not extend past end of body content'
          false
        end
      end # class Prolog::UseCases::ValidateSelection::FormObject
    end # class Prolog::UseCases::ValidateSelection
  end
end
