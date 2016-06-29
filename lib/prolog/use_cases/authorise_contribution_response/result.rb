# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Reports whether a current user is authorised to Respond to a Proposed
    # Contribution and that the Proposal has not yet been Responded to.
    class AuthoriseContributionResponse
      # Spartan `Result` value object for `AuthoriseContributionResponse`; only
      # has `#errors` and a `#success?` helper.
      class Result < Dry::Types::Value
        attribute :errors, Types::ErrorArray

        def success?
          errors.empty?
        end
      end # class Prolog::UseCases::AuthoriseContributionResponse::Result
    end # class Prolog::UseCases::AuthoriseContributionResponse
  end
end
