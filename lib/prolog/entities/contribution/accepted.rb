# frozen_string_literal: true

require_relative './responded'

module Prolog
  module Entities
    module Contribution
      # Accepted-Contribution entity.
      class Accepted < Responded
        attribute :updated_body, Types::Strict::String.constrained(min_size: 1)
      end # class Prolog::Entities::Contribution::Accepted
    end
  end
end
