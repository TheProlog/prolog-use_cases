
require 'forwardable'

require_relative 'summarise_content/article_lister.rb'
require_relative 'summarise_content/article_sorter.rb'

module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent. This includes,
    # but is notlimited to, a list of most-recent articles.
    class SummariseContent
      private_constant :ArticleLister, :ArticleSorter

      extend Forwardable
      include Wisper::Publisher

      def call
        load_article_list
      end

      def most_recent_articles
        sort_article_list(sort_by: :created_at).reverse
      end

      def most_recently_updated_articles
        sort_article_list(sort_by: :updated_at).reverse
      end

      private

      attr_reader :article_list

      def load_article_list
        @article_list = ArticleLister.new broadcast: method(:broadcast)
        article_list.call
        self
      end

      def sort_article_list(sort_by:)
        articles = article_list&.articles
        return [] unless articles
        ArticleSorter.new(articles: articles, sort_by: sort_by).call
      end
    end # class Prolog::UseCases::SummariseContent
  end
end
