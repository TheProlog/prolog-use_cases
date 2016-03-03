
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      def initialize(article_repo:, authoriser:, contribution_repo:)
        @article_repo = article_repo
        @authoriser = authoriser
        @contribution_repo = contribution_repo
        self
      end

      def call(article_ident:, endpoints:, justification:, proposed_content:)
        _article = find_article_based_on article_ident
        _current_user = authoriser.current_user
        _last_id = contribution_repo.last_contribution_id
        # Shut Reek up until we get real code in here
        _ = [endpoints, justification, proposed_content]
        self
      end

      private

      attr_reader :article_repo, :authoriser, :contribution_repo

      # Exercises the '#find' interface on a repository (an Article repository).
      class RepoClient
        def initialize(repo)
          @repo = repo
          self
        end

        def find_first(**params)
          result = @repo.find(params).first
          result || :not_found
        end
      end

      def find_article_based_on(ident)
        RepoClient.new(article_repo).find_first ident.to_h
      end
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
