
require 'ffaker'

require_relative 'item_factory'

# Builds a sequence containing a specified number of `Article` instances with
# fixture data, suitable for persisting as YAML.
class ArticleFixtureBuilder
  # Builds a list of fixture image URLs which can then be (destructively)
  # sampled.
  class ImageUrlFactory < ItemFactory
    def initialize(count)
      new_item = -> { FFaker::Avatar.image(nil, '120x120') }
      super count: count, new_item: new_item
    end
  end # class ArticleFixtureBuilder::ImageUrlFactory
end # class ArticleFixtureBuilder
