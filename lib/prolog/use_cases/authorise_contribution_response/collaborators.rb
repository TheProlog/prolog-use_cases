# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Reports whether a current user is authorised to Respond to a Proposed
    # Contribution and that the Proposal has not yet been Responded to.
    class AuthoriseContributionResponse
      # Collect all collaborators for Authorise Contribution Response use case
      # in a value object.
      class Collaborators < Dry::Types::Value
        attribute :article_repo, Types::Class
        attribute :authoriser, Types::Class
        attribute :contribution_repo, Types::Class
      end # class Prolog::UseCases::AuthoriseContributionResponse::Collaborators
    end # class Prolog::UseCases::AuthoriseContributionResponse
  end
end
