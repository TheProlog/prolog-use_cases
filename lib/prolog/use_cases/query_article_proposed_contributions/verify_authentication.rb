# frozen_string_literal: true

module Prolog
  module UseCases
    # Queries for Contribution Proposals that have been submitted but not yet
    # Responded to, that are Proposed against an Article published by the
    # currently loggedd-in Member.
    class QueryArticleProposedContributions
      # Verifies that `authoriser` does not report the Guest User as the
      # "current user"; returns an error item otherwise.
      class VerifyAuthentication
        def self.call(authoriser)
          return {} unless authoriser.guest?
          { current_user: :not_logged_in }
        end
      end # class ...::QueryArticleProposedContributions::VerifyAuthentication
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
