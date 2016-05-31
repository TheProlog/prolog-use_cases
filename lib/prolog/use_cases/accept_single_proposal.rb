# frozen_string_literal: true

require 'forwardable'

require_relative './accept_single_proposal/collaborators'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Accept a
    # Contribution that has been Proposed against it.
    class AcceptSingleProposal
      def initialize(article_repo:, authoriser:, contribution_repo:)
        params = { article_repo: article_repo, authoriser: authoriser,
                   contribution_repo: contribution_repo }
        @collaborators = Collaborators.new params
        self
      end
    end # class Prolog::UseCases::AcceptSingleProposal
  end
end
