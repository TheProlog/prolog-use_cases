
require 'forwardable'

require_relative 'summarise_content/article_lister'
require_relative 'summarise_content/article_sorter'
require_relative 'summarise_content/keyword_counter'

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
        build_return_hash
      end

      private

      attr_reader :article_list

      def build_return_hash
        {
          articles: article_list.articles,
          keywords_by_frequency: keywords_by_frequency,
          most_recent_articles: most_recent_articles,
          most_recently_updated_articles: most_recently_updated_articles
        }
      end

      def if_articles_exist(on_empty:)
        articles = article_list&.articles
        return on_empty unless articles
        yield articles
      end

      def keywords_by_frequency
        if_articles_exist(on_empty: {}) do |articles|
          KeywordCounter.new(articles).call
        end
      end

      def load_article_list
        @article_list = ArticleLister.new broadcast: method(:broadcast)
        article_list.call
        self
      end

      def most_recent_articles
        sort_article_list(sort_by: :created_at).reverse
      end

      def most_recently_updated_articles
        sort_article_list(sort_by: :updated_at).reverse
      end

      def sort_article_list(sort_by:)
        if_articles_exist(on_empty: []) do |articles|
          ArticleSorter.new(articles: articles, sort_by: sort_by).call
        end
      end
    end # class Prolog::UseCases::SummariseContent
  end
end
