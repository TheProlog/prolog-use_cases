# frozen_string_literal: true

module Prolog
  module UseCases
    # For a logged-in (authenticated) Member, return a Hash containing lists of
    # each Proposed or Responded Contribution by that Member, with accompanying
    # conventional sugar.
    class SummariseOwnContribHistory
      def self.call(authoriser:, contribution_repo:)
        SummariseOwnContribHistory.new(contribution_repo).call authoriser
      end

      def call(_authoriser)
      end

      protected

      def initialize(contribution_repo)
        @contribution_repo = contribution_repo
      end

      private

      attr_reader :contribution_repo
    end # class Prolog::UseCases::SummariseOwnContribHistory
  end
end
