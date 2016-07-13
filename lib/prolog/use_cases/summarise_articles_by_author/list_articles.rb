# frozen_string_literal: true

require_relative 'result'

module Prolog
  module UseCases
    # Just what it says on the tin: like SummariseContent for a single Author.
    class SummariseArticlesByAuthor
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
          Result.new articles: articles, errors: [], keywords: []
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
    end # class Prolog::UseCases::SummariseContent
  end
end
