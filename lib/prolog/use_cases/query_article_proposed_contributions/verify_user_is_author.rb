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
      class VerifyUserIsAuthor
        def self.call(authoriser, article_id)
          return {} if authoriser.user_name == article_id.author_name
          { current_user: :not_author }
        end
      end # class ...::QueryArticleProposedContributions::VerifyUserIsAuthor
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
