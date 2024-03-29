# frozen_string_literal: true

require 'forwardable'

require_relative './authorise_contribution_response/collaborators'
require_relative './authorise_contribution_response/result'
require_relative './authorise_contribution_response/verify_not_yet_responded'

module Prolog
  module UseCases
    # Reports whether a current user is authorised to Respond to a Proposed
    # Contribution and that the Proposal has not yet been Responded to.
    class AuthoriseContributionResponse
      extend Forwardable

      def initialize(article_repo:, authoriser:, contribution_repo:)
        params = { article_repo: article_repo, authoriser: authoriser,
                   contribution_repo: contribution_repo }
        @collaborators = Collaborators.new params
        self
      end

      def call(proposal:)
        Result.new errors: find_errors(proposal),
                   article: article_from_repo(proposal)
      end

      private

      def_delegators :@collaborators, :article_repo, :authoriser,
                     :contribution_repo

      def article_from_repo(proposal)
        ret = article_repo.find(proposal.article_id).first
        ret || :no_article_found
      end

      def find_errors(proposal)
        find_errors_for(proposal).reject(&:empty?)
      end

      def find_errors_for(proposal)
        [
          verify_current_user_is_author(proposal),
          verify_not_yet_responded(proposal)
        ]
      end

      def verify_current_user_is_author(proposal)
        return {} if authoriser.current_user == proposal.author_name
        { current_user: :not_author }
      end

      def verify_not_yet_responded(proposal)
        VerifyNotYetResponded.call repo: contribution_repo, proposal: proposal
      end
    end # class Prolog::UseCases::AuthoriseContributionResponse
  end
end
