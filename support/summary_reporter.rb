
require_relative 'timestamp_reporter'

class SummaryReporter
  def initialize(articles)
    @articles = articles
    self
  end

  def to_s
    titleize('Brief summary data:') + report_keywords +
      report_timestamps(:created_at) + report_timestamps(:updated_at) +
      report_originals + trailer
  end

  private

  attr_reader :articles

  def highlight(item)
    item.to_s.bold.cyan
  end

  def keywords
    @keywords ||= articles.map(&:keywords).map(&:to_a).flatten.sort
  end

  def report_keywords
    %Q(There are #{highlight(keywords.count)} keywords in all articles, ) +
      %Q(using #{highlight(keywords.uniq.count)} unique keywords.\n) +
      'We recommend using at least twice the number of unique keywords in ' +
      "data.\n"
  end

  def report_originals
    originals = articles.select do |article|
      article.updated_at == article.created_at
    end
    "There are #{originals.count} articles that have never been updated.\n\n"
  end

  def report_timestamps(field)
    TimestampReporter.new(articles, field).to_s + "\n"
  end

  def titleize(string)
    "\n#{string.bold.white}\n\n"
  end

  def trailer
    %Q(You may wish to examine the generated output further in a Pry/IRB ) +
      %Q(session before moving it to test/fixtures/articles.yaml\n)
  end
end
