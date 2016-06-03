# frozen_string_literal: true

require 'forwardable'

require 'prolog/entities/contribution/accepted'

# require_relative './accept_single_proposal/attributes'
require_relative './accept_single_proposal/collaborators'
require_relative './accept_single_proposal/result'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Accept a
    # Contribution that has been Proposed against it.
    class AcceptSingleProposal
      extend Forwardable

      def initialize(article_repo:, authoriser:, contribution_repo:)
        params = { article_repo: article_repo, authoriser: authoriser,
                   contribution_repo: contribution_repo }
        @collaborators = Collaborators.new params
        self
      end

      def call(proposal:)
        @proposal = proposal
        result
      end

      private

      attr_reader :proposal

      # def_delegators :@attributes, :article, :errors, :original_content,
      #                :proposal

      def_delegators :proposal, :endpoints

      def_delegators :@collaborators, :article_repo, :authoriser,
                     :contribution_repo

      def accepted_entity
        Prolog::Entities::Contribution::Accepted.new accepted_entity_attribs
      end

      def accepted_entity_attribs
        { article_id: proposal.article_id, proposal_id: proposal.identifier,
          updated_body: '<p>This is <em>updated</em> content.</p>',
          identifier: nil, responded_at: nil, response_text: nil }
      end

      def article
        find_article.first
      end

      def errors
        @errors ||= []
      end

      def find_article
        article_repo.find(proposal.article_id)
      end

      def original_content
        article.body[endpoints]
      end

      def result
        Result.new result_params
      end

      def result_params
        { entity: accepted_entity, errors: errors, proposal: proposal,
          original_content: original_content }
      end
    end # class Prolog::UseCases::AcceptSingleProposal
  end
end
