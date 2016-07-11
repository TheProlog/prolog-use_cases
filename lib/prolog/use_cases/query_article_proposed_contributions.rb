# frozen_string_literal: true

require_relative 'query_article_proposed_contributions/result'
require_relative 'query_article_proposed_contributions/search_result'
require_relative 'query_article_proposed_contributions/verify_authentication'

module Prolog
  module UseCases
    # Queries for Contribution Proposals that have been submitted but not yet
    # Responded to, that are Proposed against an Article published by the
    # currently loggedd-in Member.
    class QueryArticleProposedContributions
      # Runs validation steps for use case.
      class Validator
        def self.call(authoriser)
          _to_hash Array(VerifyAuthentication.call(authoriser))
        end

        def self._to_hash(errors)
          errors.map { |error| { error.first => error.last } }
        end
      end # class Prolog::UseCases::QueryArticleProposedContributions::Validator

      # Methods that neither depend on nor affect instance state.
      module Internals
        def self.contrib_search_params(article_id)
          article_id.to_hash.merge(responded_at: nil)
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
        @article_id = article_id
        Result.new errors: errors, proposals: proposals
      end

      private

      attr_reader :article_id, :article_repo, :authoriser, :contribution_repo

      def errors
        Validator.call authoriser
      end

      def proposals
        return [] unless errors.empty?
        proposals_for_article
      end

      def proposals_for_article
        params = Internals.contrib_search_params(article_id)
        SearchResult.call repo: contribution_repo, search_params: params
      end
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
