# frozen_string_literal: true

require 'forwardable'

require_relative './accept_single_proposal/collaborators'
require_relative './accept_single_proposal/result'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Accept a
    # Contribution that has been Proposed against it.
    class AcceptSingleProposal
      def initialize(article_repo:, authoriser:, contribution_repo:)
        params = { article_repo: article_repo, authoriser: authoriser,
                   contribution_repo: contribution_repo }
        @collaborators = Collaborators.new params
        self
      end

      def call(proposal:)
        dummy_result_for(proposal)
      end

      private

      # FIXME: Reek sees this as a :reek:UtilityFunction -- for now.
      def dummy_result_for(proposal)
        Result.new errors: [], original_proposal: proposal,
                   article: proposal.article, original_content: 'Original Here'
      end
    end # class Prolog::UseCases::AcceptSingleProposal
  end
end
