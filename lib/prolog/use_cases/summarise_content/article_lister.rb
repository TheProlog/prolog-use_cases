
module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent.
    class SummariseContent
      # Build list of articles visible in system (perhaps to "current user").
      class ArticleLister
        attr_reader :articles

        def initialize(repository:)
          @articles = []
          @repository = repository
          self
        end

        def call
          load_article_list
        end

        private

        attr_reader :repository

        def load_article_list
          @articles = repository.all
          self
        end
      end # class Prolog::UseCases::SummariseContent::ArticleLister
    end # class Prolog::UseCases::SummariseContent
  end
end
