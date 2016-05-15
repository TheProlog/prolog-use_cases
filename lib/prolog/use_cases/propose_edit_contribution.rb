# frozen_string_literal: true

require 'forwardable'

require_relative 'propose_edit_contribution/attributes'
require_relative 'propose_edit_contribution/collaborators'
require_relative 'propose_edit_contribution/transfer_errors'
require_relative 'propose_edit_contribution/validate_attributes'
require_relative 'propose_edit_contribution/wrap_contribution'

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
    # Reek says this class smells of :reek:TooManyMethods as we transition away
    # from using the form object. FIXME
    # Reek says this class smells of :reek:TooManyInstanceVariables as we
    # transition away from using the form object. FIXME
    # Reek also says that this smells of :reek:DataClump as we transition from
    # the form object to the value objects; FIXME.
    class ProposeEditContribution
      extend Forwardable

      attr_reader :contribution

      def initialize(authoriser:, contribution_repo:, article_repo:,
                     ui_gateway:)
        params = { authoriser: authoriser, contribution_repo: contribution_repo,
                   article_repo: article_repo, ui_gateway: ui_gateway }
        @collaborators = Collaborators.new params
        self
      end

      def call(article:, endpoints:, proposed_content:, justification: '')
        build_attributes article, endpoints, proposed_content, justification
        run_steps
        self
      end

      private

      def_delegators :@collaborators, :article_repo, :authoriser,
                     :contribution_repo, :ui_gateway, :user_name
      def_delegators :@attributes, :article, :article_id, :endpoints,
                     :justification, :proposed_content, :status

      def build_attributes(article, endpoints, proposed_content, justification)
        @attributes = Attributes.new article: article, endpoints: endpoints,
                                     justification: justification,
                                     proposed_content: proposed_content,
                                     proposed_at: nil, proposed_by: user_name
        self
      end

      def run_steps
        steps_in_process if validator_valid?
        transfer_errors
        self
      end

      # FIXME: Replace call to #form_object_valid? with this when FO goes away.
      def validator_valid?
        ValidateAttributes.new.call(@attributes).valid?
      end

      def steps_in_process
        update_article_with_marked_body
        persist_contribution
        persist_article
        notify_success
        self
      end

      def notify_success
        ui_gateway.success success_payload.to_json
      end

      def persist_article
        article_repo.add article
      end

      def persist_contribution
        contribution_repo.add updated_contribution
      end

      def success_payload
        { member: user_name, article_id: @attributes.article_id,
          contribution_count: contribution_repo.count }
      end

      def transfer_errors
        TransferErrors.call attributes: @attributes, ui_gateway: ui_gateway
        self
      end

      def update_article_with_marked_body
        article = updated_article(updated_count_from_repo)
        attribs = updated_article_attributes article
        @attributes = Attributes.new attribs
        self
      end

      def updated_article(count)
        WrapContribution.call id_number: count,
                              attributes: @attributes
      end

      def updated_article_attributes(article)
        attribs = @attributes.to_h
        attribs[:article] = article
        attribs
      end

      def updated_contribution
        @contribution ||= contribution_repo.create @attributes
      end

      def updated_count_from_repo
        contribution_repo.count + 1
      end
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
