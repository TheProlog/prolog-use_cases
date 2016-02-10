
require 'ffaker'

require_relative 'item_factory'

# Builds a sequence containing a specified number of `Article` instances with
# fixture data, suitable for persisting as YAML.
class ArticleFixtureBuilder
  # Builds lists of "keywords" using a keyword list sampled from a bogus
  # word/phrase list. Uses that list to build a list of lists, including random
  # keywords from the first list. That list of lists is then made available for
  # (destructive) sampling. Each sample will always be a (possibly empty) array
  # of strings where each may have one or more words.
  class KeywordListFactory < ItemFactory
    def initialize(count, keyword_source_count = 80, max_count = 5)
      @words = FFaker::HipsterIpsum.words keyword_source_count
      new_item = -> { @words.sample rand(0..max_count) }
      super count: count, new_item: new_item, sanitize: :to_a
    end
  end # class ArticleFixtureBuilder::KeywordListFactory
end # class ArticleFixtureBuilder
