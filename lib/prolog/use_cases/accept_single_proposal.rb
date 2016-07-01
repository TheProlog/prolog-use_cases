# frozen_string_literal: true

require 'forwardable'

require 'prolog/entities/contribution/accepted'

require_relative './accept_single_proposal/attributes'
require_relative './accept_single_proposal/build_updated_body'
require_relative './accept_single_proposal/result'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Accept a
    # Contribution that has been Proposed against it. Presumes that the use case
    # "Authorise Contribution Response" has already been executed successfully,
    # and thus performs *no* error checking.
    class AcceptSingleProposal
      extend Forwardable

      def initialize(article:)
        @article = article
        self
      end

      def call(proposal:, response_text:)
        @attributes = Attributes.new proposal: proposal, identifier: nil,
                                     response_text: response_text
        result
      end

      private

      attr_reader :article

      def_delegators :@attributes, :identifier, :proposal, :response_text
      def_delegators :proposal, :article_id, :original_content
      def_delegator :proposal, :identifier, :proposal_id

      def accepted_entity
        Prolog::Entities::Contribution::Accepted.new accepted_entity_attribs
      end

      def accepted_entity_attribs
        { article_id: article_id, proposal_id: proposal_id,
          updated_body: updated_body, identifier: identifier,
          response_text: response_text, responded_at: nil }
      end

      def result
        Result.new result_params
      end

      # We no longer have *any* validation in this class so, as far as
      # we know, nothing can go wrong...or be recovered from if it does.
      #
      # However, we retain the `:errors` attribute by convention, just in
      # case that changes in future.
      def result_params
        { entity: accepted_entity, errors: [], proposal: proposal,
          original_content: original_content }
      end

      def updated_body
        BuildUpdatedBody.new(updated_body_params).call
      end

      def updated_body_params
        { article: article, identifier: identifier, proposal: proposal }
      end
    end # class Prolog::UseCases::AcceptSingleProposal
  end
end
