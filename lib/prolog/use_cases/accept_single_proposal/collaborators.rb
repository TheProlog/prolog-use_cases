# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Accept a
    # Contribution that has been Proposed against it.
    class AcceptSingleProposal
      # Collect all collaborators for RTSP use case in a value object.
      class Collaborators < Dry::Types::Value
        attribute :article_repo, Types::Class
        attribute :authoriser, Types::Class
        attribute :contribution_repo, Types::Class
      end # class Prolog::UseCases::AcceptSingleProposal::Collaborators
    end # class Prolog::UseCases::AcceptSingleProposal
  end
end
