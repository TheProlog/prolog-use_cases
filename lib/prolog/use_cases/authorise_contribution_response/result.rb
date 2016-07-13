# frozen_string_literal: true

require 'prolog/entities/result/base'

module Prolog
  module UseCases
    # Reports whether a current user is authorised to Respond to a Proposed
    # Contribution and that the Proposal has not yet been Responded to.
    class AuthoriseContributionResponse
      # Besides reporting any detected errors, the `Result` value object for
      # `AuthoriseContributionResponse` now has an `:article` attribute. This
      # should return the Article entity associated with the current workflow
      # *as retrieved from the Article Repository.*
      class Result < Prolog::Entities::Result::Base
        attribute :article, Types::Class
      end # class Prolog::UseCases::AuthoriseContributionResponse::Result
    end # class Prolog::UseCases::AuthoriseContributionResponse
  end
end
