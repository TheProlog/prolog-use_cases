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
    # FIXME: Reek complains that this has :reek:TooManyMethods, ,saying "at
    # least 17 methods". It does need to be broken out more **or** the Flay
    # score ignored.
    class ProposeEditContribution
      extend Forwardable

      attr_reader :contribution

      def initialize(authoriser:, contribution_factory:)
        params = { authoriser: authoriser,
                   contribution_factory: contribution_factory }
        @collaborators = Collaborators.new params
        @contribution = @attributes = nil
        @errors = []
        self
      end

      def call(article:, endpoints:, proposed_content:, justification: '')
        build_attributes article, endpoints, proposed_content, justification
        run_steps
        build_result
      end

      private

      attr_reader :attributes

      def_delegators :@collaborators, :authoriser, :contribution_factory,
                     :user_name
      def_delegators :@attributes, :article, :article_id, :contribution_id,
                     :endpoints, :justification, :proposed_content, :status

      def build_attributes(article, endpoints, proposed_content, justification)
        @attributes = Attributes.new article: article, endpoints: endpoints,
                                     justification: justification,
                                     proposed_content: proposed_content,
                                     proposed_at: nil, proposer: user_name,
                                     contribution_id: nil
        self
      end

      def build_result
        Result.new errors: @errors, article: article,
                   contribution: updated_contribution
      end

      def run_steps
        steps_in_process if valid_inputs?
        self
      end

      def add_errors(new_errors)
        @errors << new_errors # unless new_errors.empty?
        normalize_errors
        @errors.empty?
      end

      def attribute_errors
        ValidateAttributes.new.call(attributes).errors
      end

      def attributes_valid?
        add_errors attribute_errors
        @errors.empty?
      end

      def author_is_current_user?
        article.author_name == user_name
      end

      def author_not_logged_in_error
        { not_logged_in: article_id }
      end

      def current_user_valid?
        add_errors(author_not_logged_in_error) unless author_is_current_user?
        @errors.empty?
      end

      def normalize_errors
        @errors = unique_errors.reject(&:empty?)
      end

      def unique_errors
        Set.new(@errors).to_a.flatten
      end

      def steps_in_process
        update_article_with_marked_body
        self
      end

      def update_article_with_marked_body
        @attributes = UpdateAttributesWithMarkedBody.call attributes: attributes
        self
      end

      def updated_contribution
        @contribution ||= contribution_factory.call attributes
      end

      def valid_inputs?
        attributes_valid? && current_user_valid?
      end
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
