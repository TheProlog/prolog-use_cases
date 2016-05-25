# frozen_string_literal: true

require 'forwardable'

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
        extend Forwardable

        attribute :authoriser, Types::Class
        attribute :contribution_repo, Types::Class
        attribute :article_repo, Types::Class

        def_delegators :authoriser, :user_name
      end # class Prolog::UseCases::ProposeEditContribution::Collaborators
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
