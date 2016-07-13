# frozen_string_literal: true

require 'prolog/entities/result/base'

module Prolog
  module UseCases
    # For a logged-in (authenticated) Member, return a Hash containing lists of
    # each Proposed or Responded Contribution by that Member, with accompanying
    # conventional sugar.
    class SummariseOwnContribHistory
      # Value object communicating result of use case to caller.
      class Result < Prolog::Entities::Result::Base
        attribute :contributions, Types::ContributionHash
      end # class Prolog::UseCases::SummariseOwnContribHistory::Result
    end # class Prolog::UseCases::SummariseOwnContribHistory
  end
end
