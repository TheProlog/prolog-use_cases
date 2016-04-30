# frozen_string_literal: true

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

        def build_indexes
          ret = {}
          keyword_counts.each_value { |index| ret[index] = [] }
          ret
        end

        def load_indexes(result)
          keyword_counts.each { |str, index| result[index] << str }
          result
        end

        def list_keywords_by_count
          load_indexes(build_indexes)
        end
      end # class Prolog::UseCases::SummariseContent::KeywordCounter
    end # class Prolog::UseCases::SummariseContent
  end
end
