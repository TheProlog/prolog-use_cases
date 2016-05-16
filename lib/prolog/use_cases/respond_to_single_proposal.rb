# frozen_string_literal: true

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Respond to a
    # Contribution that has been Proposed against it.
    class RespondToSingleProposal
      def initialize(article_repo:, authoriser:, contribution_repo:)
        @article_repo = article_repo
        @authoriser = authoriser
        @contribution_repo = contribution_repo
        self
      end

      private

      attr_reader :article_repo, :authoriser, :contribution_repo
    end # class Prolog::UseCases::RespondToSingleProposal
  end
end
