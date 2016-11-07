# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Accept a
    # Contribution that has been Proposed against it.
    class AcceptSingleProposal
      # Encapsulates attributes used during use case.
      class Attributes < ::Dry::Struct
        attribute :identifier, Types::UUID
        attribute :proposal, Types::Class
        attribute :response_text, Types::Strict::String.default('')
      end # class Prolog::UseCases::RespondToSingleProposal::Attributes
    end # class Prolog::UseCases::RespondToSingleProposal
  end
end
