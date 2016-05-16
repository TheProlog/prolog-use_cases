# frozen_string_literal: true
# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Validates value attributes sent to `ProposeEditContribution#call`.
      class ValidateAttributes
        # Simple cclass to check if proposer is guest user, building error data
        # if so.
        class CheckProposer
          def self.call(proposed_by:, article_id:)
            CheckProposer.new(proposed_by, article_id).call
          end

          def call
            return [] unless guest?
            JSON.dump(error_data)
          end

          protected

          def initialize(proposed_by, article_id)
            @proposed_by = proposed_by
            @article_id = article_id
            self
          end

          private

          attr_reader :article_id, :proposed_by

          GUEST_USER_NAME = 'Guest User'

          def error_data
            { failure: 'not logged in', article_id: YAML.dump(article_id.to_h) }
          end

          def guest?
            !proposer? || proposed_by == GUEST_USER_NAME
          end

          def proposer?
            !proposed_by.to_s.empty?
          end
        end # class ...::ValidateAttributes::CheckProposer
      end # class Prolog::UseCases::ProposeEditContribution::ValidateAttributes
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
