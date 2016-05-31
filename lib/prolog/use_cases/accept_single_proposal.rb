# frozen_string_literal: true

require 'forwardable'

require_relative './accept_single_proposal/attributes'
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
        update_attributes_from(proposal)
        result
      end

      private

      def_delegators :@attributes, :article, :errors, :original_content,
                     :proposal

      def_delegators :@collaborators, :article_repo, :authoriser,
                     :contribution_repo

      def content_from_proposal
        # FIXME: Pull selected content out of `proposal.article.body`. Hmm. LOD?
        'Dummy Original Content'
      end

      def result
        Result.new result_params
      end

      def result_params
        { article: article, errors: errors, original_content: original_content,
          original_proposal: proposal }
      end

      def update_attributes_from(proposal)
        params = { article: updated_article, errors: [],
                   original_content: content_from_proposal, proposal: proposal }
        @attributes = Attributes.new params
        self
      end

      # FIXME: Reek sees this as a :reek:UtilityFunction -- for now.
      def updated_article
        Struct.new(:body).new 'FIXME: DUMMY UPDATED ARTICLE'
      end
    end # class Prolog::UseCases::AcceptSingleProposal
  end
end
