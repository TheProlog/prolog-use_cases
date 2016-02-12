
class TimestampReporter
  def initialize(articles, field)
    timestamps = articles.map { |article| article.send field }.flatten.uniq.sort
    @earliest = timestamps.first
    @latest = timestamps.last
    @field_str = field.to_s.sub('_', '-')
    self
  end

  def to_s
    field_str = highlight(@field_str)
    earliest = highlight(@earliest)
    latest = highlight(@latest)
    "The earliest #{field_str} timestamp is #{earliest}, and the latest is " +
      "#{latest}."
  end

  private

  def highlight(item)
    item.to_s.bold.cyan
  end
end
