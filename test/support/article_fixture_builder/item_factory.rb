# frozen_string_literal: true

# Builds a sequence containing a specified number of `Article` instances with
# fixture data, suitable for persisting as YAML.
class ArticleFixtureBuilder
  # Base class for a number of builders of lists of attribute values which can
  # then be sampled. Sampling is destructive by default (removing the sampled
  # item from the collection); it can be overridden to be non-destructive (as
  # for author names, for example). The `:sanitize` symbol answers the question,
  # "what do we do to `nil` when we're asked for a sample and we don't have any
  # left?"
  class ItemFactory
    # use :at as `sampler` for non-destructive sampling
    def initialize(count:, new_item:, sampler: :delete_at, sanitize: :to_s)
      @items = []
      @new_item = new_item
      @sampler = sampler
      @sanitize = sanitize
      load_items count
    end

    def sample
      sample_item_at rand(items.count)
    end

    private

    attr_reader :items, :new_item, :sampler, :sanitize

    def load_items(count)
      while items.count < count
        items << new_item.call
        items.uniq!
      end
      self
    end

    def sample_item_at(index)
      items.send(sampler, index).send(sanitize)
    end
  end # class ArticleFixtureBuilder::ItemFactory
end # class ArticleFixtureBuilder
