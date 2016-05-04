# frozen_string_literal: true

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Respond to a
    # Contribution that has been Proposed against it.
    class RespondToSingleProposal
      # Returns information about the success or failure of the action.
      class Result
      end

      def initialize(article_repo:, authoriser:, contribution_repo:)
        @article_repo = article_repo
        @authoriser = authoriser
        @contribution_repo = contribution_repo
        self
      end

      # Reek flags this as a :reek:UtilityFunction -- for now.
      def call(proposal:)
        _ = proposal
        Result.new
      end

      private

      attr_reader :article_repo, :authoriser, :contribution_repo
    end # class Prolog::UseCases::RespondToSingleProposal
  end
end
