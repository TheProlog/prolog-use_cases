# frozen_string_literal: true

require_relative 'query_article_proposed_contributions/result'

module Prolog
  module UseCases
    # Queries for Contribution Proposals that have been submitted but not yet
    # Responded to, that are Proposed against an Article published by the
    # currently loggedd-in Member.
    class QueryArticleProposedContributions
      # Methods that neither depend on nor affect instance state.
      module Internals
        def self.contrib_search_params(article_id)
          article_id.to_hash.merge(responded_at: nil)
        end

        def self.search_result_as_array(results)
          results == :not_found ? [] : results
        end
      end
      private_constant :Internals

      def initialize(article_repo:, authoriser:, contribution_repo:)
        @article_repo = article_repo
        @authoriser = authoriser
        @contribution_repo = contribution_repo
        self
      end

      def call(article_id:)
        # errors = validate article_id
        errors = []
        proposals = errors.empty? ? proposals_for(article_id) : []
        Result.new errors: errors, proposals: proposals
      end

      private

      attr_reader :article_repo, :authoriser, :contribution_repo

      def proposals_for(article_id)
        params = Internals.contrib_search_params(article_id)
        proposals = contribution_repo.find(params)
        Internals.search_result_as_array proposals
      end
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
