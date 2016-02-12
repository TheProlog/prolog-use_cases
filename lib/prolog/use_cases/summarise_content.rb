
require 'forwardable'

require_relative 'summarise_content/article_lister'
require_relative 'summarise_content/article_sorter'
require_relative 'summarise_content/keyword_counter'

module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent.
    class SummariseContent
      private_constant :ArticleLister, :ArticleSorter

      extend Forwardable
      include Wisper::Publisher

      # The `#call` method returns a Hash with four entries in it:
      #
      # * `:articles` references an array of all `Article` entities which the
      #   persistence subsystem (or "port") makes available. This is
      #   accomplished by way of a Wisper conversation; a message is broadcast
      #   asking for all articles, and an array of Article instances is read
      #   from the payload of another message sent subsequent to (conceptually,
      #   in reply to) the first message. Currently, *no error handling* for
      #   contingencies such as no articles being received is in place; this
      #   code will perform as though no articles are available. Without an
      #   array of articles as referenced here, none of the other entries in the
      #   Hash returned by `#call` will be meaningful.
      # * `:keywords_by_frequency` references a Hash whose keys are integers and
      #   whose values are arrays of strings. The value strings, collectively,
      #   include all keywords defined in all `:articles`; each keyword occurs a
      #   total number of times (in the article corpus) matching the index of
      #   the hash entry in which it occurs. For example, a keyword "dunsel"
      #   that occurs 6 times in total would be part of the array referenced by
      #   `SummariseContent.new.call[:keywords_by_frequency][6]`.
      # * `:most_recent_articles` references an array of all `Article` entities,
      #   sorted by creation date/time, in descending order (most recent first).
      #   This is distinct from `:articles`, which simply returns a list of the
      #   same `Article` entities in the order supplied by the persistence port.
      # * `:most_recently_updated_articles` references an array of all `Article`
      #   entities, sorted by latest update date/time, in descending order (most
      #   recent first). As with `:most_recent_articles`, this is a convenience
      #   that simply reorders the same data as returned in the `:articles`
      #   entry.
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
