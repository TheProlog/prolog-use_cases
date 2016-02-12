
require_relative 'keyword_counter/counts'
require_relative 'keyword_counter/list_builder'

module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent. This includes,
    # but is notlimited to, a list of most-recent articles.
    class SummariseContent
      # Builds a list of all keywords in each Article within a collection of
      # Articles
      class KeywordCounter
        def initialize(articles)
          @articles = articles
          self
        end

        def call
          find_all_keywords
          count_keywords
          list_keywords_by_count
        end

        private

        attr_reader :articles, :keywords, :keyword_counts

        def count_keywords
          @keyword_counts = Counts.new(keywords).call
          self
        end

        def find_all_keywords
          @keywords = ListBuilder.new(articles).call
          self
        end

        def list_keywords_by_count
          init_kbc_hash.tap do |keywords_by_count|
            keyword_counts.each do |word, count|
              keywords_by_count[count] << word
            end
          end
        end

        def init_kbc_hash
          {}.tap do |keywords_by_count|
            (1..keyword_counts.values.max).each do |index|
              keywords_by_count[index] = []
            end
          end
        end
      end # class Prolog::UseCases::SummariseContent::KeywordCounter
    end # class Prolog::UseCases::SummariseContent
  end
end
