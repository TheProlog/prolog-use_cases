
require 'ffaker'

require_relative 'item_factory'

# Builds a sequence containing a specified number of `Article` instances with
# fixture data, suitable for persisting as YAML.
class ArticleFixtureBuilder
  # Builds a list of author names (Western-conventional first and last names,
  # separated by a space). The `#sample` method takes a (non-destructive) sample
  # for use in a fixture article.
  class AuthorFactory < ItemFactory
    def initialize(count)
      new_item = lambda do
        [FFaker::Name.first_name, FFaker::Name.last_name].join ' '
      end
      super count: count, new_item: new_item, sampler: :at
    end
  end # class ArticleFixtureBuilder::AuthorFactory
end # class ArticleFixtureBuilder
