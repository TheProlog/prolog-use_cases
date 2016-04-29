# frozen_string_literal: true

require 'ffaker'

require_relative 'item_factory'

# Builds a sequence containing a specified number of `Article` instances with
# fixture data, suitable for persisting as YAML.
class ArticleFixtureBuilder
  # Builds a list of fixture titles which can then be (destructively) sampled.
  class TitleFactory < ItemFactory
    def initialize(count)
      new_item = -> { FFaker::Movie.title }
      super count: count, new_item: new_item
    end
  end # class ArticleFixtureBuilder::TitleFactory
end # class ArticleFixtureBuilder
