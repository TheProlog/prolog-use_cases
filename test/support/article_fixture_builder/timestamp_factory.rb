# frozen_string_literal: true

# Builds a sequence containing a specified number of `Article` instances with
# fixture data, suitable for persisting as YAML.
class ArticleFixtureBuilder
  # Builds a single per-sample timestamp within a range defined by a starting
  # point (as a `Time` instance), a range in seconds from which to create sample
  # values, and a range of valid hours for those timestamps (to restrict to the
  # standard prime-shift business day, use a value of [9..17]) for values from
  # 09:00:00 local to 17:59:59 local (on any unrestricted day of the week).
  class TimestampFactory
    def initialize(range_start, range_seconds, valid_hours)
      @hours = valid_hours
      @range_start = range_start.to_i
      @range_size = range_seconds.to_i
      self
    end

    def sample
      sample_from_range until valid_hour?
      convert
    end

    private

    attr_reader :hours, :range_size, :range_start, :ticks

    def convert
      ret = Time.at(range_start + ticks).to_datetime
      @ticks = nil
      ret
    end

    def sample_from_range
      @ticks = rand(range_size)
      self
    end

    def valid_hour?
      return false unless ticks
      sampled_time = Time.at(range_start + ticks)
      hours.include? sampled_time.hour
    end
  end # class ArticleFixtureBuilder::TimestampFactory
end # class ArticleFixtureBuilder
