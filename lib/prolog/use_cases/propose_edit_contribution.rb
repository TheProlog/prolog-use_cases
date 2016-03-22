
require 'forwardable'

# Hack to use Rails' broken :delegate rather than the standard library's.
# Yes, this is obscene.
module Forwardable
  remove_method :delegate
end

require_relative 'propose_edit_contribution/content_validator'
require_relative 'propose_edit_contribution/form_object'
require_relative 'propose_edit_contribution/form_object_two_stage'

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
    # Reek says this class smells of :reek:TooManyInstanceVariables; we'll worry
    # about that sometime in The Glorious Future.
    class ProposeEditContribution
      extend Forwardable

      attr_reader :contribution

      def initialize(article:, authoriser:, contribution_repo:, article_repo:,
                     ui_gateway:)
        @form_object = FormObjectTwoStage.init(article, authoriser)
        # init_form_object article, authoriser
        @contribution_repo = contribution_repo
        @article_reop = article_repo
        @ui_gateway = ui_gateway
        self
      end

      def call(endpoints:, proposed_content:, justification: '')
        FormObjectTwoStage.update(@form_object, endpoints, proposed_content,
                                  justification)
        steps_in_process unless inputs_invalid?
        self
      end

      private

      attr_reader :contribution_repo, :form_object, :ui_gateway

      delegate :article_id, :guest, :proposed_content, :user_name,
               :wrap_contribution_with, to: :@form_object

      def inputs_invalid?
        guest_user? || content_validator.invalid?(proposed_content)
      end

      def content_validator
        ContentValidator.new(ui_gateway, user_name, article_id)
      end

      def guest_failure_payload
        { failure: 'not logged in', article_id: article_id }
      end

      def guest_user?
        return false unless guest
        ui_gateway.failure guest_failure_payload.to_json
        true
      end

      def steps_in_process
        update_body
        persist_contribution
        notify_success
        self
      end

      def notify_success
        ui_gateway.success success_payload.to_json
      end

      def persist_contribution
        contribution_repo.add updated_contribution
      end

      def success_payload
        { member: user_name, article_id: article_id,
          contribution_count: contribution_repo.count }
      end

      def update_body
        wrap_contribution_with contribution_repo.count + 1
      end

      def updated_contribution
        @contribution ||= contribution_repo.create form_object.to_h
      end
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
