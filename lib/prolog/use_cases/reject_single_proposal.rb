# frozen_string_literal: true

require 'forwardable'

require 'prolog/entities/contribution/rejected'

require_relative './reject_single_proposal/result'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Reject a
    # Contribution that has been Proposed against it. Presumes that the use case
    # "Authorise Contribution Response" has already been executed successfully,
    # and thus performs *no* error checking.
    class RejectSingleProposal
      def initialize(article:)
        @article = article
        self
      end

      def call(proposal:, response_text:)
        @proposal = proposal
        @response_text = response_text
        Result.new errors: [], entity: article, proposal: proposal,
                   original_content: proposal.original_content
      end

      private

      attr_reader :article, :proposal, :response_text
    end # class Prolog::UseCases::RejectSingleProposal
  end
end
