
module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent. This includes,
    # but is notlimited to, a list of most-recent articles.
    class SummariseContent
      # Builds a list of all keywords in each Article within a collection of
      # Articles
      class KeywordCounter
        # Builds combined list of all keywords in all articles.
        class ListBuilder
          def initialize(articles)
            @articles = articles
          end

          def call
            finalize(array_from(keyword_lists))
          end

          private

          attr_reader :articles

          # This methods smells of :reek:UtilityFunction, and we don't care now.
          def array_from(list_of_word_sets)
            list_of_word_sets.map(&:to_a)
          end

          # This methods smells of :reek:UtilityFunction, and we don't care now.
          def finalize(words_array)
            words_array.flatten.sort
          end

          def keyword_lists
            articles.map(&:keywords)
          end
        end # class ...::UseCases::SummariseContent::KeywordCounter::ListBuilder
      end # class Prolog::UseCases::SummariseContent::KeywordCounter
    end # class Prolog::UseCases::SummariseContent
  end
end
