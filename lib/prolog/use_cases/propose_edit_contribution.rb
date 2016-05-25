# frozen_string_literal: true

require 'forwardable'

require_relative './propose_edit_contribution/result'

%w(attributes
   collaborators
   update_article_with_marked_body
   validate_attributes).each do |fname|
     require_relative "./propose_edit_contribution/#{fname}"
   end

# "Propose Edit Contribution" use case.
#
# A full writeup of the use case, its inputs, success and failure scenarios, and
# other closely-related items, now lives in the project's GitHub repo Wiki page
# entitled `Use Case Description: "Propose Edit Contribution"`. If you can read
# this, you should have access to that Wiki page, which is hereafter the Single
# Source of Truth for this class' requirements.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      extend Forwardable

      attr_reader :contribution

      def initialize(authoriser:, contribution_repo:)
        params = { authoriser: authoriser,
                   contribution_repo: contribution_repo }
        @collaborators = Collaborators.new params
        self
      end

      def call(article:, endpoints:, proposed_content:, justification: '')
        build_attributes article, endpoints, proposed_content, justification
        run_steps
        build_result
      end

      private

      def_delegators :@collaborators, :authoriser, :contribution_repo,
                     :user_name
      def_delegators :@attributes, :article, :article_id, :endpoints,
                     :justification, :proposed_content, :status

      def build_attributes(article, endpoints, proposed_content, justification)
        @attributes = Attributes.new article: article, endpoints: endpoints,
                                     justification: justification,
                                     proposed_content: proposed_content,
                                     proposed_at: nil, proposed_by: user_name
        self
      end

      def build_result
        Result.new errors: @errors, article: article,
                   contribution: updated_contribution
      end

      def run_steps
        steps_in_process if validator_valid?
        @errors = []
        self
      end

      def validator_valid?
        ValidateAttributes.new.call(@attributes).valid?
      end

      def steps_in_process
        update_article_with_marked_body
        self
      end

      def update_article_with_marked_body
        params = { attributes: @attributes }
        @attributes = UpdateAttributesWithMarkedBody.call params
        self
      end

      def updated_contribution
        # NOTE: The one and only method still used on `contribution_repo`.
        @contribution ||= contribution_repo.create @attributes
      end
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
