
require_relative 'timestamp_factory'

# Builds a sequence containing a specified number of `Article` instances with
# fixture data, suitable for persisting as YAML.
class ArticleFixtureBuilder
  # Builds a single timestamp "later than" a starting time, but before an ending
  # time (which defaults to the current local time), limited to a range of valid
  # hours for sample timestamps. By default, these samples are restricted to the
  # standard prime-shift business day using a value of [9..17]) for values from
  # 09:00:00 local to 17:59:59 local (on any unrestricted day of the week).
  class LaterTimestampFactory < TimestampFactory
    def initialize(start_time:, end_time: Time.now, hours: 9..17)
      starting_time = start_time.to_time
      range_seconds = end_time.to_i - starting_time.to_i
      super starting_time, range_seconds, hours
      self
    end
  end # class ArticleFixtureBuilder::LaterTimestampFactory
end # class ArticleFixtureBuilder
