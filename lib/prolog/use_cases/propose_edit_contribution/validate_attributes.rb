# frozen_string_literal: true

require 'forwardable'

require_relative 'validate_attributes/check_content'
require_relative 'validate_attributes/check_endpoints'
require_relative 'validate_attributes/check_proposer'

# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    # Reek says this class smells of :reek:TooManyInstanceVariables; we'll worry
    # about that sometime in The Glorious Future.
    # Reek also says that this smells of :reek:DataClump as we transition from
    # the form object to the value objects; FIXME.
    class ProposeEditContribution
      # Validates value attributes sent to `ProposeEditContribution#call`.
      class ValidateAttributes
        attr_reader :errors

        def initialize
          @errors = {}
          self
        end

        def call(attributes)
          @attributes = attributes
          validate
          self
        end

        def valid?
          raise 'No attributes defined' unless attributes
          errors.empty?
        end

        private

        extend Forwardable

        GUEST_USER_NAME = 'Guest User'

        attr_reader :attributes

        def_delegators :attributes, :article, :article_id, :endpoints,
                       :proposed_by, :proposed_content

        def validate
          proposed_by_member? && proposed_content? && endpoints_ok?
        end

        def check_attribute(error_key, checker_sym)
          error_data = method(checker_sym).call
          return true if error_data.empty?
          errors[error_key] = error_data
          false
        end

        def proposed_by_member?
          check_attribute :authoriser, :check_proposer
        end

        def check_proposer
          CheckProposer.call(proposed_by: proposed_by, article_id: article_id)
        end

        def proposed_content?
          check_attribute :proposed_content, :check_content
        end

        def check_content
          CheckContent.call(proposed_content: proposed_content,
                            article_id: article_id)
        end

        def endpoints_ok?
          check_attribute :endpoints, :check_endpoints
        end

        def check_endpoints
          CheckEndpoints.call check_endpoints_params
        end

        def check_endpoints_params
          { article_body: article.body, endpoints: endpoints,
            article_id: article_id }
        end
      end # class Prolog::UseCases::ProposeEditContribution::ValidateAttributes
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
