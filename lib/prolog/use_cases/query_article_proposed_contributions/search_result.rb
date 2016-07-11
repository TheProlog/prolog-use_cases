# frozen_string_literal: true

module Prolog
  module UseCases
    # Queries for Contribution Proposals that have been submitted but not yet
    # Responded to, that are Proposed against an Article published by the
    # currently loggedd-in Member.
    class QueryArticleProposedContributions
      # Encapsulates result of searching a repo with parameters
      class SearchResult
        def self.call(repo:, search_params:)
          SearchResult.new(repo).call(search_params)
        end

        def call(params)
          results = @repo.find params
          return [] if results == :not_found
          results
        end

        protected

        def initialize(repo)
          @repo = repo
          self
        end
      end # class ...::UseCases::QueryArticleProposedContributions::SearchResult
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
