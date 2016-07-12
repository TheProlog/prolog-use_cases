# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Just what it says on the tin: like SummariseContent for a single Author.
    class SummariseArticlesByAuthor
      # Result notification encapsulation for query.
      class Result < Dry::Types::Value
        attribute :articles, Types::Strict::Array
        attribute :errors, Types::ErrorArray
        attribute :keywords, Types::Strict::Array.default([])

        def success?
          errors.empty?
        end
      end # class Prolog::UseCases::SummariseArticlesByAuthor::Result
    end # class Prolog::UseCases::SummariseArticlesByAuthor
  end
end
