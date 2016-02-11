
require 'prolog/core'

require_relative 'article_fixture_builder/author_factory'
require_relative 'article_fixture_builder/body_factory'
require_relative 'article_fixture_builder/image_url_factory'
require_relative 'article_fixture_builder/keyword_list_factory'
require_relative 'article_fixture_builder/later_timestamp_factory'
require_relative 'article_fixture_builder/past_timestamp_factory'
require_relative 'article_fixture_builder/title_factory'

# Builds a sequence containing a specified number of `Article` instances with
# fixture data, suitable for persisting as YAML.
#
# An Article fixture has apparently valid but randomly-generated values for each
# field, including `:author_name`, `:body`, `:created_at`, `:image_url`,
# `:keywords`, `#title`, and `:updated_at`. Image URL will always be present;
# keywords will be a list of up to 5 "keywords" that may be empty; and an
# article may be in its "original form", shown by its updated-at timestamp being
# identical to its created-at timestamp, or it may "have been edited", in which
# case the update timestamp will be later than the creation timestamp (but both
# are guaranteed to be before the current local time).
# This class reeks of :reek:TooManyInstanceVariables; we don't care (for now).
class ArticleFixtureBuilder
  attr_reader :list

  def initialize(count)
    @count = count
    build_list
  end

  private

  attr_reader :count

  # Yes, these factories could be DRYed up; it would be much easier if we Hard
  # access to something that worked like ActiveSupport's `String#constantize`.
  # Until we find an alternative, we'll just have to suck it up.

  def author_factory
    author_count = (count * 0.4).to_i
    @author_factory ||= AuthorFactory.new author_count
  end

  def body_factory
    @body_factory ||= BodyFactory.new count
  end

  def build_attributes
    created_at = created_at_factory.sample
    { author_name: author_factory.sample, body: body_factory.sample,
      created_at: created_at, image_url: image_url_factory.sample,
      keyword_list: keyword_list_factory.sample, title: title_factory.sample,
      updated_at: LaterTimestampFactory.new(start_time: created_at).sample }
  end

  def build_list
    @list = count.times.map { Prolog::Core::Article.new build_attributes }
    self
  end

  # This method smells of :reek:UtilityFunction and we don't care (for now).
  def created_at_factory
    PastTimestampFactory.new
  end

  def image_url_factory
    @image_url_factory ||= ImageUrlFactory.new count
  end

  def keyword_list_factory
    @keyword_list_factory ||= KeywordListFactory.new count
  end

  def title_factory
    @title_factory ||= TitleFactory.new count
  end
end # class ArticleFixtureBuilder
