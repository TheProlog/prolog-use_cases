# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Reports results from execution of `#call` method.
      class Result < Dry::Types::Value
        attribute :errors, Types::Strict::Array.member(Types::Strict::Hash)

        def success
          errors.empty?
        end
        alias success? success
      end # class Prolog::UseCases::ProposeEditContribution::Result
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
