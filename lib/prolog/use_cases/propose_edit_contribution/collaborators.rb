# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Objects providing services to the use case. We *could* be more specific,
      # or define a validation schema for this. Maybe, in The Glorious Future.
      class Collaborators < Dry::Types::Value
        attribute :authoriser, Types::Class
        attribute :contribution_repo, Types::Class
        attribute :article_repo, Types::Class
        attribute :ui_gateway, Types::Class
      end # class Prolog::UseCases::ProposeEditContribution::Collaborators
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
