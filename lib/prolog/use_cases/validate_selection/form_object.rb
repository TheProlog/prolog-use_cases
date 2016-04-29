
require 'active_model'
require 'virtus'

require 'prolog/support/form_object/integer_range'

require_relative './form_object/proposal_field_tester'

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
          attribute :authoriser, Object
          attribute :replacement_content, String
        end

        ATTR_REQUIRED = '%{value} is required.'.freeze
        validates_presence_of :article, message: ATTR_REQUIRED
        validates_presence_of :authoriser, message: ATTR_REQUIRED
        validates_presence_of :replacement_content, message: ATTR_REQUIRED

        validate :authoriser_logged_in
        validate :endpoints_supplied
        validate :endpoints_within_article_body
        validate :body_valid_after_replacement

        private

        def authoriser_logged_in
          return false unless authoriser.respond_to? :guest?
          return true unless authoriser.guest?
          errors.add :current_user, 'not logged in'
          false
        end

        def body_valid_after_replacement
          return true if _replacement_valid?
          errors.add :replacement_content, 'invalid'
          false
        end

        def endpoints_supplied
          return true unless endpoints == (-1..-1)
          errors.add :endpoints, ' is required.'
          false
        end

        def _end_endpoint_within_body?
          length = article&.body&.length.to_i
          endpoints.end <= length
        end

        def end_endpoint_less_than_length?
          return true if _end_endpoint_within_body?
          errors.add :endpoint, 'end out of range'
          false
        end

        def endpoints_within_article_body
          return true if end_endpoint_less_than_length?
          errors.add :endpoints, 'must not extend past end of body content'
          false
        end

        def _replacement_valid?
          return false unless replacement_content
          ProposalFieldTester.accepts? self, :replacement
        end
      end # class Prolog::UseCases::ValidateSelection::FormObject
    end # class Prolog::UseCases::ValidateSelection
  end
end
