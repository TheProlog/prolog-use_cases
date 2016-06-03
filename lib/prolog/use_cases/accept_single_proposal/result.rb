# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Accept a
    # Contribution that has been Proposed against it.
    class AcceptSingleProposal
      # Encapsulates result reported from use case.
      class Result < Dry::Types::Value
        attribute :entity, Types::Class # Accepted-Contribution entity
        attribute :errors, Types::ErrorArray
        attribute :original_content, Types::Strict::String
        attribute :proposal, Types::Class

        def response
          :accepted
        end

        def accepted?
          true
        end

        def rejected?
          false
        end

        def responded?
          true
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
