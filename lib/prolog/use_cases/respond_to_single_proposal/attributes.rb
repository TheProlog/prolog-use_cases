# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Respond to a
    # Contribution that has been Proposed against it.
    class RespondToSingleProposal
      # Collect data items for this use case's `#call` method.
      class Attributes < Dry::Types::Value
        attribute :proposal, Types::Class
        attribute :responder, Types::Class

        # def to_h
        #   { proposal: proposal, response: response }
        # end
      end # class Prolog::UseCases::RespondToSingleProposal::Attributes
    end # class Prolog::UseCases::RespondToSingleProposal
  end
end
