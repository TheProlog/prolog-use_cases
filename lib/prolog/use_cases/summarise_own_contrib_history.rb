# frozen_string_literal: true

require 'forwardable'

require_relative './summarise_own_contrib_history/result'

module Prolog
  module UseCases
    # For a logged-in (authenticated) Member, return a Hash containing lists of
    # each Proposed or Responded Contribution by that Member, with accompanying
    # conventional sugar.
    class SummariseOwnContribHistory
      def self.call(authoriser:, contribution_repo:)
        SummariseOwnContribHistory.new(contribution_repo).call authoriser
      end

      def call(authoriser)
        @authoriser = authoriser
        result
      end

      protected

      def initialize(contribution_repo)
        @contribution_repo = contribution_repo
      end

      private

      extend Forwardable

      attr_reader :authoriser, :contribution_repo
      def_delegators :authoriser, :guest?, :user_name

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

      def result
        return successful_result unless guest?
        Internals.failed_result
      end

      def successful_result
        Result.new errors: [], contributions: all_contributions
      end

      # Methods neither affecting nor dependent on instance state.
      module Internals
        def self.failed_result
          errors = [{ current_user: :not_logged_in }]
          Result.new errors: errors, contributions: {}
        end
      end
      private_constant :Internals
    end # class Prolog::UseCases::SummariseOwnContribHistory
  end
end
