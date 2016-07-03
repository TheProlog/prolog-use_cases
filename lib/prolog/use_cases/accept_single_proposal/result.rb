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
        attribute :response, Types::ContributionResponse

        def accepted?
          response == :accepted
        end

        def rejected?
          response == :rejected
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
      end # class Prolog::UseCases::AcceptSingleProposal::Result
    end # class Prolog::UseCases::AcceptSingleProposal
  end
end
