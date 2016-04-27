
require 'prolog/entities/article_ident'

module Prolog
  module UseCases
    # Queries for Contribution Proposals that have been submitted but not yet
    # Responded to, that are Proposed against an Article published by the
    # currently loggedd-in Member.
    class QueryArticleProposedContributions
      def initialize(article_repo:, authoriser:, contribution_repo:)
        @article_repo = article_repo
        @authoriser = authoriser
        @contribution_repo = contribution_repo
        self
      end

      # Reek thinks this stub of a method is a :reek:UtilityFunction -- for now.
      def call(article_id:)
        _ = article_id
        Struct.new(:success?).new true
      end

      private

      attr_reader :article_repo, :authoriser, :contribution_repo
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
