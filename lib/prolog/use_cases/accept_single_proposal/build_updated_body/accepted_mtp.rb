# frozen_string_literal: true

# Builds an accepted-contribution marker tag pair based on an identifier string.
class AcceptedMTP
  def initialize(identifier)
    @identifier = identifier
    self
  end

  def to_str
    %(<a id="contribution-#{identifier}"></a>)
  end

  private

  attr_reader :identifier
end
