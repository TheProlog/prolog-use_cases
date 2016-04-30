# frozen_string_literal: true

require 'prolog/entities/proposal'

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
        errors = validate article_id
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

      def validate(article_id)
        current_user_errors(article_id).merge article_errors(article_id)
      end

      def article_errors(article_id)
        article = article_repo.find article_id
        article == :not_found ? { article: ['not found'] } : {}
      end

      def current_user_errors(article_id)
        errors = validate_current_user(article_id)
        errors.empty? ? {} : { current_user: errors }
      end

      def validate_current_user(article_id)
        verify_logged_in + verify_author(article_id)
      end

      def verify_author(article_id)
        authoriser.user_name == article_id.author_name ? [] : ['not author']
      end

      def verify_logged_in
        authoriser.guest? ? ['not logged in'] : []
      end
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
