# frozen_string_literal: true

require 'prolog/entities/article_ident'
require 'prolog/support/form_object/integer_range'

module Prolog
  module Entities
    # Value object representing an open Contribution Proposal
    class Proposal
      include Virtus.value_object
      include Prolog::Support::FormObject

      values do
        attribute :article_id, Prolog::Entities::ArticleIdent
        attribute :proposer, String
        attribute :endpoints, IntegerRange
        attribute :proposed_content, String
        attribute :justification, String
        attribute :type, Symbol, default: -> (_, _) { :edit }
        attribute :proposed_at, DateTime, default: -> (_, _) { DateTime.now }
      end
    end # class Prolog::Entities::Proposal
  end
end
