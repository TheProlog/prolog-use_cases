
# frozen_string_literal: true
require 'uuid'

require 'prolog/support/dry_types_setup'

require 'prolog/entities/article_ident_v'

module Prolog
  module Entities
    module Contribution
      # Proposed-Contribution entity;
      class Proposed < Dry::Types::Value
        attribute :article_id, ArticleIdentV
        attribute :endpoints, Types::IntegerRange
        attribute :justification, Types::Strict::String.default('')
        attribute :proposed_content, Types::Strict::String
        attribute :proposer, Types::Strict::String
        # attribute :type, Types::Symbol.default(:edit)
        attribute :proposed_at, Types::Strict::DateTime.default { DateTime.now }
        attribute :identifier, Types::UUID

        def type # Not settable as an attribute...yet.
          :edit
        end

        def to_h
          super.merge(type: type)
        end
      end # class Prolog::Entities::Contribution::Proposed
    end
  end
end
