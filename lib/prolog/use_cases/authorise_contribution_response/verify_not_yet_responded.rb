# frozen_string_literal: true

module Prolog
  module UseCases
    # Reports whether a current user is authorised to Respond to a Proposed
    # Contribution and that the Proposal has not yet been Responded to.
    class AuthoriseContributionResponse
      # Verifies that no existing response to a proposal exists in repo.
      class VerifyNotYetResponded
        def self.call(repo:, proposal:)
          _entry_for _existing_contribution(repo, proposal)
        end

        def self._entry_for(contribution)
          return {} unless contribution
          { contribution_responded_to: contribution.identifier }
        end

        def self._existing_contribution(repo, proposal)
          repo.find(proposal_id: proposal.identifier).first
        end
      end # class ...::AuthoriseContributionResponse::VerifyNotYetResponded
    end # class Prolog::UseCases::AuthoriseContributionResponse
  end
end
