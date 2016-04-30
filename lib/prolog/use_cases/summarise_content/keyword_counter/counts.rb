# frozen_string_literal: true

module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent. This includes,
    # but is notlimited to, a list of most-recent articles.
    class SummariseContent
      # Builds a list of all keywords in each Article within a collection of
      # Articles
      class KeywordCounter
        # Actually builds keywords-by-count list used by `KeywordCounter`.
        class Counts
          def initialize(keywords)
            @keywords = keywords
            self
          end

          def call
            keywords_as_set.map { |kw| keyword_with_count(kw) }.to_h
          end

          private

          attr_reader :keywords

          def keyword_with_count(keyword)
            [keyword, keywords.count(keyword)]
          end

          def keywords_as_set
            Set.new(keywords)
          end
        end # class Prolog::UseCases::SummariseContent::KeywordCounter::Counts
      end # class Prolog::UseCases::SummariseContent::KeywordCounter
    end # class Prolog::UseCases::SummariseContent
  end
end
