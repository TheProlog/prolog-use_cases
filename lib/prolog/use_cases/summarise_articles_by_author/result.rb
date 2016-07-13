# frozen_string_literal: true

require 'prolog/entities/result/base'

module Prolog
  module UseCases
    # Just what it says on the tin: like SummariseContent for a single Author.
    class SummariseArticlesByAuthor
      # Result notification encapsulation for query.
      class Result < Prolog::Entities::Result::Base
        attribute :articles, Types::Strict::Array
        attribute :keywords, Types::Strict::Array.default([])
      end # class Prolog::UseCases::SummariseArticlesByAuthor::Result
    end # class Prolog::UseCases::SummariseArticlesByAuthor
  end
end
