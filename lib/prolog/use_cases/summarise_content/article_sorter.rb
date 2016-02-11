
module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent. This includes,
    # but is notlimited to, a list of most-recent articles.
    class SummariseContent
      # Simple sort of a list of articles by a single specified field.
      class ArticleSorter
        def initialize(articles:, sort_by:)
          @articles = articles
          @field = sort_by
          self
        end

        def call
          articles.sort { |first, second| compare_articles first, second }
        end

        private

        attr_reader :articles, :field

        def compare_articles(first, second)
          field_from(first) <=> field_from(second)
        end

        def field_from(article)
          article.send field
        end
      end # class Prolog::UseCases::SummariseContent::ArticleSorter
    end # class Prolog::UseCases::SummariseContent
  end
end
