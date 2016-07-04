# frozen_string_literal: true

require 'forwardable'

require 'prolog/entities/contribution/rejected'
require 'prolog/entities/result/response'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Reject a
    # Contribution that has been Proposed against it. Presumes that the use case
    # "Authorise Contribution Response" has already been executed successfully,
    # and thus performs *no* error checking.
    class RejectSingleProposal
      extend Forwardable

      def initialize(article:)
        @article = article
        self
      end

      def call(proposal:, response_text:)
        @proposal = proposal
        @response_text = response_text
        @identifier = UUID.generate
        Result.new result_params
      end

      private

      attr_reader :article, :identifier, :proposal, :response_text

      Result = Prolog::Entities::Result::Response

      def_delegators :proposal, :article_id
      def_delegator :proposal, :identifier, :proposal_id

      def entity
        Prolog::Entities::Contribution::Rejected.new entity_attribs
      end

      def entity_attribs
        { article_id: article_id, proposal_id: proposal_id,
          updated_body: updated_body, identifier: identifier,
          response_text: response_text, responded_at: nil }
      end

      def result_params
        { response: :rejected, errors: [], entity: entity, proposal: proposal,
          original_content: proposal.original_content }
      end

      def updated_body
        article.body
      end
    end # class Prolog::UseCases::RejectSingleProposal
  end
end
