# frozen_string_literal: true

require 'forwardable'

module Prolog
  module UseCases
    # Just what it says on the tin: like SummariseContent for a single Author.
    class SummariseArticlesByAuthor
      # Result notification encapsulation for query.
      class Result
        attr_reader :articles, :errors, :keywords

        def initialize(errors:, articles:, keywords: [])
          @errors = errors
          @articles = articles
          @keywords = keywords
          self
        end

        def success?
          errors.empty?
        end
      end # class Prolog::UseCases::SummariseArticlesByAuthor::Result

      # Build list of articles by author visible to current user.
      class ListArticles
        def initialize(repository:, author_name:, authoriser:)
          @author_name = author_name
          @current_user = authoriser.current_user
          @repository = repository
          self
        end

        def call
          articles = filter(articles_by_author)
          Result.new articles: articles, errors: []
        end

        private

        attr_reader :author_name, :current_user, :repository

        def articles_by_author
          repository.find(author_name: author_name)
        end

        def author?(article)
          current_user == article.author_name
        end

        def filter(articles)
          articles.select do |article|
            article.published? || author?(article)
          end
        end
      end # class Prolog::UseCases::SummariseContent::ListArticles

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
          _keyword_set_from(_all_keywords_in(articles))
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
