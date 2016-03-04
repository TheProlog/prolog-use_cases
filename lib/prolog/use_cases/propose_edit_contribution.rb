
require 'forwardable'

require_relative 'propose_edit_contribution/form_object'

module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      extend Forwardable

      def initialize(article_repo:, authoriser:, contribution_repo:)
        @form_obj = FormObject.new article_repo: article_repo,
                                   authoriser: authoriser,
                                   contribution_repo: contribution_repo
        self
      end

      def call(article_ident:, endpoints:, justification:, proposed_content:)
        call_params_to_fo article_ident, endpoints, justification,
                          proposed_content
        _ = [article, current_user, last_contribution_id]
        #
        # *Magic* Happens Here...
        self
      end

      private

      delegate [:article, :current_user, :last_contribution_id] => :@form_obj

      # delegate [:article_repo, :authoriser, :contribution_repo,
      #           :markdown_converter] => :@form_obj

      def call_params_to_fo(article_ident, endpoints, justification, content)
        @form_obj.article_ident = article_ident
        @form_obj.endpoints = endpoints
        @form_obj.justification = justification
        @form_obj.proposed_content = content
      end
    end # class Prolog::UseCases::ProposeEditContribution

    # Added features for testing that we don't want in the production class.
    class ProposeEditContributionTestEnhancer < ProposeEditContribution
      delegate [:markdown_converter, :markdown_converter=] => :@form_obj
    end
  end
end
