# frozen_string_literal: true

require 'forwardable'

require_relative './respond_to_single_proposal/attributes'
require_relative './respond_to_single_proposal/collaborators'
require_relative './respond_to_single_proposal/result'

module Prolog
  module UseCases
    # Encapsulates logic whereby an Author of an Article may Respond to a
    # Contribution that has been Proposed against it.
    # Reek is also now telling us that this has :reek:TooManyMethods. As usual,
    # it's right; we break a lot of things down into tiny pieces for SRP (e.g.,
    # `#contribution_responded?`) that ought to be broken out. But each of those
    # preconditions is *just enough different* that the Grand Unified Superclass
    # eludes us. FIXME
    class RespondToSingleProposal
      def initialize(article_repo:, authoriser:, contribution_repo:)
        @collaborators = Collaborators.new article_repo: article_repo,
                                           authoriser: authoriser,
                                           contribution_repo: contribution_repo
        self
      end

      def call(proposal:, responder:)
        setup_for_call(proposal, responder)
        query_response
        result
      end

      private

      extend Forwardable

      def_delegators :@attributes, :proposal, :responder

      def_delegators :@collaborators, :article_repo, :authoriser,
                     :contribution_repo

      def_delegators :authoriser, :current_user, :guest?

      def_delegators :proposal, :article_id, :author_name, :identifier,
                     :proposer

      attr_reader :errors, :response

      def author_is_current_user?
        author_name == current_user
      end

      def author_is_proposer?
        author_name == proposer
      end

      def contribution_in_repo
        contribution_repo.find identifier: identifier
      end

      def responded_contributions
        contribution_in_repo.select(&:responded_at)
      end

      def contribution_responded?
        !responded_contributions.empty?
      end

      def report_author_is_proposer
        errors << { proposer: :is_author }
        false
      end

      def report_contribution_responded
        errors << { status: :responded }
        false
      end

      def report_not_author
        errors << { current_user: :not_author }
        false
      end

      def query_response
        @response = responder.call(proposal) if verify_preconditions
        self
      end

      def result
        Result.new result_params
      end

      def result_params
        { errors: errors, original_proposal: proposal, response: response }
      end

      def setup_for_call(proposal, responder)
        @attributes = Attributes.new proposal: proposal, responder: responder
        @errors = []
        @response = :undefined
        self
      end

      def verify_author_not_proposer
        !author_is_proposer? || report_author_is_proposer
      end

      def verify_current_user
        author_is_current_user? || report_not_author
      end

      def verify_not_responded
        !contribution_responded? || report_contribution_responded
      end

      def verify_preconditions
        verify_current_user && verify_author_not_proposer &&
          verify_not_responded
      end
    end # class Prolog::UseCases::RespondToSingleProposal
  end
end
