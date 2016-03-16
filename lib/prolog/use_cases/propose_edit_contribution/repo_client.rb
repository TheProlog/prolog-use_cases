
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Exercises the '#find' interface on a repository (an Article repository).
      class RepoClient
        def initialize(repo)
          @repo = repo
          self
        end

        def find_first(**params)
          result = repo.find(params).first
          result || :not_found
        end

        private

        attr_reader :repo
      end # class Prolog::UseCases::ProposeEditContribution::RepoClient
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
