
require 'ffaker'

require_relative 'item_factory'

# Builds a sequence containing a specified number of `Article` instances with
# fixture data, suitable for persisting as YAML.
class ArticleFixtureBuilder
  # Builds a list of fixture body strings which can then be (destructively)
  # sampled.
  class BodyFactory < ItemFactory
    def initialize(count)
      new_item = -> { FFaker::HipsterIpsum.paragraphs.join("\n\n") }
      super count: count, new_item: new_item
    end
  end
end
