
require 'forwardable'

# Hack to use Rails' broken :delegate rather than the standard library's.
# Yes, this is obscene.
module Forwardable
  remove_method :delegate
end

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
      extend Forwardable

      def initialize(article:, authoriser:, contribution_repo:, article_repo:,
                     ui_gateway:)
        init_form_object article, authoriser
        @contribution_repo = contribution_repo
        @article_reop = article_repo
        @ui_gateway = ui_gateway
        self
      end

      def call(endpoints:, proposed_content:, justification: '')
        update_form_object_entering_call(endpoints, proposed_content,
                                         justification)
        update_body
        persist_contribution
        self
      end

      private

      attr_reader :contribution_repo, :form_object, :ui_gateway

      delegate :wrap_contribution_with, to: :@form_object

      def contribution
        @contribution ||= contribution_repo.create form_object.to_h
      end

      # Reek thinks this smells of :reek:FeatureEnvy wrt `authoriser`. Pffft.
      def init_form_object(article, authoriser)
        @form_object = FormObject.new article: article,
                                      guest: authoriser.guest?,
                                      user_name: authoriser.user_name
      end

      def persist_contribution
        contribution_repo.add contribution
      end

      def update_body
        wrap_contribution_with contribution_repo.count + 1
      end

      def update_form_object_entering_call(endpoints, proposed_content,
                                           justification)
        form_object.endpoints = endpoints
        form_object.justification = justification
        form_object.proposed_content = proposed_content
        self
      end
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
