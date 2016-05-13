# frozen_string_literal: true

require_relative 'validate_attributes/check_content'
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

        GUEST_USER_NAME = 'Guest User'

        attr_reader :attributes

        def validate
          proposed_by_member? && proposed_content?
        end

        def proposed_by_member?
          error_data = check_proposer
          return true if error_data.empty?
          errors[:authoriser] = error_data
          false
        end

        def check_proposer
          CheckProposer.call(proposed_by: attributes&.proposed_by,
                             article_id: attributes.article_id)
        end

        def proposed_content?
          error_data = check_content
          return true if error_data.empty?
          errors[:proposed_content] = error_data
          false
        end

        def check_content
          CheckContent.call(proposed_content: attributes&.proposed_content,
                            article_id: attributes.article_id)
        end
      end # class Prolog::UseCases::ProposeEditContribution::ValidateAttributes
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
