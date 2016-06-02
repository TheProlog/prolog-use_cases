
# frozen_string_literal: true

require 'forwardable'
require 'uuid'

require 'prolog/support/dry_types_setup'

require 'prolog/entities/article_ident_v'

module Prolog
  module Entities
    module Contribution
      # Proposed-Contribution entity;
      class Accepted < Dry::Types::Value
        extend Forwardable

        attribute :article_id, Prolog::Entities::ArticleIdentV
        attribute :identifier, Types::UUID
        attribute :proposal_id, Types::UUID
        attribute :responded_at,
                  Types::Strict::DateTime.default { DateTime.now }
        attribute :response_text, Types::Strict::String.default('')
        attribute :updated_body, Types::Strict::String.constrained(min_size: 1)

        def_delegators :article_id, :author_name, :title

        def type # Not settable as an attribute...yet.
          :edit
        end

        def to_h
          super.merge(type: type)
        end
      end # class Entities::Contribution::Accepted
    end
  end
end
