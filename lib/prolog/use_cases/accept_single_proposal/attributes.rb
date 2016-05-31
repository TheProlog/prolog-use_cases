# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Accept a
    # Contribution that has been Proposed against it.
    class AcceptSingleProposal
      # Encapsulates attributes used during use case.
      class Attributes < Dry::Types::Struct
        attribute :article, Types::Class
        attribute :errors, Types::ErrorArray
        attribute :original_content,
                  Types::Strict::String.constrained(min_size: 1)
        attribute :proposal, Types::Class
      end # class Prolog::UseCases::RespondToSingleProposal::Attributes
    end # class Prolog::UseCases::RespondToSingleProposal
  end
end
