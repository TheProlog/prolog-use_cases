# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Queries for Contribution Proposals that have been submitted but not yet
    # Responded to, that are Proposed against an Article published by the
    # currently loggedd-in Member.
    class QueryArticleProposedContributions
      # Result notification encapsulation for query.
      class Result < Dry::Types::Value
        attribute :errors, Types::ErrorArray
        attribute :proposals, Types::Strict::Array

        def success?
          errors.empty?
        end
      end # class Prolog::UseCases::QueryArticleProposedContributions::Result
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
