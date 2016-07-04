# frozen_string_literal: true

# Builds a proposed-contribution marker tag pair based on an identifier string
# and which end of the proposal is being addressed (`:begin` or `:end`).
class ProposedMTP
  def initialize(identifier, which_end)
    @identifier = identifier
    @which_end = which_end
    self
  end

  def to_str
    %(<a id="contribution-#{identifier}-#{which_end}"></a>)
  end

  private

  attr_reader :identifier, :which_end
end
