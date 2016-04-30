# frozen_string_literal: true

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
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
