
require_relative 'timestamp_factory'

# Builds a sequence containing a specified number of `Article` instances with
# fixture data, suitable for persisting as YAML.
class ArticleFixtureBuilder
  # Builds a single timestamp in the past relative to a given starting Time,
  # starting a certain number of days back and within a specified number of days
  # forward from that point.
  class PastTimestampFactory < TimestampFactory
    def initialize(from: Time.now, start: 90, days_forward: 30, hours: 9..17)
      day_seconds = 24 * 3600
      range_start = from.to_i - start * day_seconds
      range_seconds = days_forward * day_seconds
      super range_start, range_seconds, hours
      self
    end
  end # class ArticleFixtureBuilder::PastTimestampFactory
end # class ArticleFixtureBuilder
