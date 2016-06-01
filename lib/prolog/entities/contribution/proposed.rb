# frozen_string_literal: true

require 'forwardable'
require 'uuid'

require 'prolog/support/dry_types_setup'

require 'prolog/entities/article_ident_v'

module Prolog
  module Entities
    module Contribution
      # Proposed-Contribution entity;
      class Proposed < Dry::Types::Value
        extend Forwardable

        attribute :article_id, ArticleIdentV
        attribute :endpoints, Types::IntegerRange
        attribute :identifier, Types::UUID
        attribute :justification, Types::Strict::String.default('')
        attribute :proposed_at, Types::Strict::DateTime.default { DateTime.now }
        attribute :proposed_content, Types::Strict::String
        attribute :proposer, Types::Strict::String
        # attribute :type, Types::Symbol.default(:edit)

        def_delegators :article_id, :author_name, :title

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
