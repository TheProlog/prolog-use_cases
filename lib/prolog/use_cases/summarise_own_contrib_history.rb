# frozen_string_literal: true

require 'forwardable'

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
        attribute :errors, Types::Strict::Array

        def success
          errors.empty?
        end
        alias success? success

        def failure
          !success
        end
        alias failure? failure
      end # class Prolog::UseCases::SummariseOwnContribHistory::Result

      def self.call(authoriser:, contribution_repo:)
        SummariseOwnContribHistory.new(contribution_repo).call authoriser
      end

      def call(authoriser)
        @authoriser = authoriser
        Result.new errors: [], contributions: all_contributions
      end

      protected

      def initialize(contribution_repo)
        @contribution_repo = contribution_repo
      end

      private

      extend Forwardable

      attr_reader :authoriser, :contribution_repo
      def_delegators :authoriser, :user_name

      def accepted
        { accepted: contributions(:accepted) }
      end

      def all_contributions
        Hash[*collection.flatten(2)]
      end

      def collection
        accepted.zip(proposed, rejected)
      end

      def contributions(status)
        contribution_repo.find(author_name: user_name, status: status)
      end

      def proposed
        { proposed: contributions(:proposed) }
      end

      def rejected
        { rejected: contributions(:rejected) }
      end
    end # class Prolog::UseCases::SummariseOwnContribHistory
  end
end
