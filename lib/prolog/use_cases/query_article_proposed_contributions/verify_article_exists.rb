# frozen_string_literal: true

module Prolog
  module UseCases
    # Queries for Contribution Proposals that have been submitted but not yet
    # Responded to, that are Proposed against an Article published by the
    # currently loggedd-in Member.
    class QueryArticleProposedContributions
      # Verifies that `authoriser` reports the current user as having the same
      # name (presumably the same Member) as the `author_name` encoded in the
      # `article_id`.
      class VerifyArticleExists
        def self.call(article_id, article_repo)
          article = article_repo.find article_id
          return {} unless article == :not_found
          { article_not_found: JSON.dump(article_id) }
        end
      end # class ...::QueryArticleProposedContributions::VerifyArticleExists
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
