# frozen_string_literal: true

require 'forwardable'

require_relative './summarise_articles_by_author/list_articles'
require_relative './summarise_articles_by_author/result'

module Prolog
  module UseCases
    # Just what it says on the tin: like SummariseContent for a single Author.
    class SummariseArticlesByAuthor
      def initialize(authoriser:, repository:)
        @authoriser = authoriser
        @repository = repository
        self
      end

      def call(author_name:)
        @list = articles_by(author_name)
        result
      end

      private

      # NOTE: We know this doesn't really make any Forwardable methods private.
      # It does, however, show that our delegations are to be treated as though
      # they are to be used as though they were private methods.
      extend Forwardable

      attr_reader :authoriser, :repository

      def_delegators :@list, :articles, :errors

      def articles_by(author_name)
        params = { author_name: author_name, authoriser: authoriser,
                   repository: repository }
        ListArticles.new(params).call
      end

      def result
        Result.new result_params
      end

      def result_params
        { articles: articles, keywords: Internals.keywords_from(articles),
          errors: errors }
      end

      # Methods that neither affect nor depend on instance state.
      module Internals
        def self.keywords_from(articles)
          _keyword_set_from(_all_keywords_in(articles)).to_a
        end

        def self._all_keywords_in(articles)
          articles.map(&:keywords).flatten
        end

        def self._keyword_set_from(keywords)
          Set.new keywords.sort
        end
      end
      private_constant :Internals
    end # class Prolog::UseCases::SummariseArticlesByAuthor
  end
end
