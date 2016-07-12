# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # For a logged-in (authenticated) Member, return a Hash containing lists of
    # each Proposed or Responded Contribution by that Member, with accompanying
    # conventional sugar.
    class SummariseOwnContribHistory
      # Value object communicating result of use case to caller.
      class Result < Dry::Types::Value
        attribute :contributions, Types::ContributionHash
        attribute :errors, Types::ErrorArray

        def success
          errors.empty?
        end
        alias success? success

        def failure
          !success
        end
        alias failure? failure
      end # class Prolog::UseCases::SummariseOwnContribHistory::Result
    end # class Prolog::UseCases::SummariseOwnContribHistory
  end
end
