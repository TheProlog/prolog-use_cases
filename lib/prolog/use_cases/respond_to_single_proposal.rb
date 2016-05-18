# frozen_string_literal: true

require 'forwardable'

require_relative './respond_to_single_proposal/attributes'
require_relative './respond_to_single_proposal/collaborators'
require_relative './respond_to_single_proposal/result'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Respond to a
    # Contribution that has been Proposed against it.
    class RespondToSingleProposal
      def initialize(article_repo:, authoriser:, contribution_repo:)
        @collaborators = Collaborators.new article_repo: article_repo,
                                           authoriser: authoriser,
                                           contribution_repo: contribution_repo
        self
      end

      def call(proposal:, responder:)
        @attributes = Attributes.new proposal: proposal, responder: responder
        @errors = []
        result
      end

      private

      extend Forwardable

      def_delegators :@attributes, :proposal, :responder, :response

      def_delegators :@collaborators, :article_repo, :authoriser,
                     :contribution_repo

      attr_reader :errors

      def result
        Result.new result_params
      end

      def result_params
        { errors: errors, proposal: proposal, response: response }
      end
    end # class Prolog::UseCases::RespondToSingleProposal
  end
end
