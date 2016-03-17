
require_relative 'propose_edit_contribution/form_object'

# "Propose Edit Contribution" use case.
#
# Basic scenario:
#   A Member is viewing an Article on an Article Page. After selecting a range
# of body content and verifying that the selected range does not overlap Locked
# Content and that the Member is permitted to Propose Contributions to the
# Article,  (see the "Validate Selection" use case), *this* use case simply
# persists the Contribution Proposal into the Contribution Repository based on
# the supplied inputs, and reports success.
#
# On success,
# * If the current Member is the Article's Author, then a new Accepted
#   Contribution will be persisted to the Contribution Repository;
# * If the current Member is *not* the Article's Author, then a new Proposed
#   Contribution will be persisted to the Contribution Repository;
# * a UI :success notification will be emitted, with additional data including
#   the name of the currnet Member and the title of the affected Article;
#
# Failure modes:
# * The Member may no longer be logged in, generally due to a timeout or other
#   external condition. The use case reports a `'no authorised member'` error
#   and aborts the use case;
# * The proposed replacement content may be empty, blank, or omitted. This will
#   cause a `'no content'` error to be reported, and the use case will abort.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      def initialize(article:, authoriser:, contribution_repo:, ui_gateway:)
        init_form_object article, authoriser
        @contribution_repo = contribution_repo
        @ui_gateway = ui_gateway
        self
      end

      def call(endpoints:, justification:, proposed_content:)
        form_object.endpoints = endpoints
        form_object.justification = justification
        form_object.proposed_content = proposed_content
        self
      end

      private

      attr_reader :contribution_repo, :form_object, :ui_gateway

      def init_form_object(article, authoriser)
        @form_object = FormObject.new article: article, guest: authoriser.guest?
      end
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
