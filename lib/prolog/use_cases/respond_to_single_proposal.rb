# frozen_string_literal: true

require 'dry-types'

# Top-level module to isolate Dry::Types per examples.
module Types
  include Dry::Types.module
end

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Respond to a
    # Contribution that has been Proposed against it.
    class RespondToSingleProposal
      # Returns information about the success or failure of the action.
      class Result < Dry::Types::Value
        attribute :success, Types::Strict::Bool
        attribute :errors, Types::Strict::Array.member(Types::Strict::String)

        # Trivial, possibly, but Useful.
        def success?
          success
        end
      end

      def initialize(article_repo:, authoriser:, contribution_repo:)
        @article_repo = article_repo
        @authoriser = authoriser
        @contribution_repo = contribution_repo
        self
      end

      # Reek flags this as a :reek:UtilityFunction -- for now.
      def call(proposal:, accepted:)
        _ = proposal
        _ = accepted
        Result.new success: true, errors: []
      end

      private

      attr_reader :article_repo, :authoriser, :contribution_repo
    end # class Prolog::UseCases::RespondToSingleProposal
  end
end
