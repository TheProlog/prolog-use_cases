# frozen_string_literal: true

require 'forwardable'

require 'prolog/support/dry_types_setup'

require_relative 'propose_edit_contribution/form_object'

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
      # Objects providing services to the use case.
      class Collaborators < Dry::Types::Value
        attribute :authoriser, Types::Class
        attribute :contribution_repo, Types::Class
        attribute :article_repo, Types::Class
        attribute :ui_gateway, Types::Class
      end # class Prolog::UseCases::ProposeEditContribution::Collaborators

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
        build_form article, endpoints, proposed_content, justification
        run_steps
        self
      end

      private

      delegate :article_repo, :authoriser, :contribution_repo, :ui_gateway,
               to: :@collaborators

      attr_reader :form_object

      delegate :all_error_messages, :article, :article_id, :proposed_content,
               :status, :user_name, :wrap_contribution_with, to: :@form_object

      def build_form(article, endpoints, proposed_content, justification)
        params = { endpoints: endpoints, proposed_content: proposed_content,
                   justification: justification, article: article,
                   authoriser: authoriser }
        @form_object = FormObject.new params
        self
      end

      def run_steps
        steps_in_process if form_object.valid?
        transfer_errors
        self
      end

      def steps_in_process
        update_body
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
        { member: user_name, article_id: article_id,
          contribution_count: contribution_repo.count }
      end

      def transfer_errors
        all_error_messages.each { |payload| ui_gateway.failure payload }
      end

      def update_body
        wrap_contribution_with updated_count_from_repo
      end

      def updated_contribution
        @contribution ||= contribution_repo.create form_object.to_h
      end

      def updated_count_from_repo
        contribution_repo.count + 1
      end
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
