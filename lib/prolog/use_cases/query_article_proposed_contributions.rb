
require 'prolog/entities/proposal'

module Prolog
  module UseCases
    # Queries for Contribution Proposals that have been submitted but not yet
    # Responded to, that are Proposed against an Article published by the
    # currently loggedd-in Member.
    class QueryArticleProposedContributions
      # Result notification encapsulation for query.
      class Result
        attr_reader :errors, :proposals

        def initialize(errors:, proposals:)
          @errors = errors
          @proposals = proposals
          self
        end

        def success?
          errors.empty?
        end
      end # class Prolog::UseCases::QueryArticleProposedContributions::Result

      def initialize(article_repo:, authoriser:, contribution_repo:)
        @article_repo = article_repo
        @authoriser = authoriser
        @contribution_repo = contribution_repo
        self
      end

      def call(article_id:)
        # articles = article_repo.find(article_id)
        proposals = proposals_for article_id
        Result.new errors: [], proposals: proposals
      end

      private

      attr_reader :article_repo, :authoriser, :contribution_repo

      def proposals_for(article_id)
        params = article_id.to_hash.merge(responded_at: nil)
        proposals = contribution_repo.find(params)
        proposals == :not_found ? [] : proposals
      end
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
