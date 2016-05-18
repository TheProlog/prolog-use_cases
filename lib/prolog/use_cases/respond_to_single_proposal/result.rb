# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Respond to a
    # Contribution that has been Proposed against it.
    class RespondToSingleProposal
      # Encapsulates result reported from use case.
      class Result < Dry::Types::Value
        attribute :errors, Types::Strict::Array.member(Types::Strict::String)
        attribute :response, Types::Strict::Symbol

        def accepted?
          response == :accepted
        end

        def rejected?
          response == :rejected
        end

        def success?
          errors.empty?
        end

        # def to_h
        #   super.merge(success: success?)
        # end
      end # class Prolog::UseCases::RespondToSingleProposal::Result
    end # class Prolog::UseCases::RespondToSingleProposal
  end
end
