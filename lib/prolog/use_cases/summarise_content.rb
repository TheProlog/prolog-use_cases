
require 'prolog/core'

module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent. This includes,
    # but is not necessarily limited to, a list of most-recent articles.
    class SummariseContent
      include Wisper::Publisher

      attr_reader :articles

      def call
        load_article_list
      end

      def all_articles(articles)
        @articles = articles
        self
      end

      private

      def load_article_list
        Wisper.subscribe(self) { broadcast :query_all_articles }
        self
      end
    end # class Prolog::UseCases::SummariseContent
  end
end
