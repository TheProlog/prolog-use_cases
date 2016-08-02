# frozen_string_literal: true

require 'forwardable'
require 'uuid'

require 'prolog/support/dry_types_setup'

require 'prolog/entities/article_ident_v'

module Prolog
  module Entities
    module Contribution
      # Responded-Contribution entity (base for Accepted or Rejected).
      class Responded < ::Dry::Types::Value
        extend Forwardable

        attribute :article_id, Prolog::Entities::ArticleIdentV
        attribute :identifier, Types::UUID
        attribute :proposal_id, Types::UUID
        attribute :responded_at, Types::TimeOrNow
        attribute :response_text, Types::Strict::String.default('')

        def_delegators :article_id, :author_name, :title

        def type # Not settable as an attribute...yet.
          :edit
        end

        def to_h
          super.merge(type: type)
        end
      end # class Prolog::Entities::Contribution::Responded
    end
  end
end
