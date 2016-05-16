# frozen_string_literal: true

require 'dry-types'

# These need to be before `Dryp::Types.module` is included. Also,
# obviously, after requiring `dry-types`.
Dry::Types.register 'range', Dry::Types::Definition[Range].new(Range)
Dry::Types.register 'strict.range',
                    Dry::Types['range'].constrained(type: Range)

# `Types` as a top-level namespace module seems to be a `dry-types`
# convention.
module Types
  include Dry::Types.module

  IntegerRange = Range.constructor do |value|
    if value.is_a?(::Range)
      value
    elsif value.to_i == 0
      -1..-1
    else
      0..value.to_i
    end
  end

  UUID_FORMAT = /\A\h{8}(-\h{4}){3}\-\h{12}\z/
  UUID = Types::Strict::String.default { ::UUID.generate }
                              .constrained(format: UUID_FORMAT)
end
