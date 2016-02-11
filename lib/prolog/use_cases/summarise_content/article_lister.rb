
require 'wisper'

module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent.
    class SummariseContent
      # Build list of articles visible in system (perhaps to "current user").
      class ArticleLister
        attr_reader :articles

        # Why shouldn't this be a Wisper publisher in its own right? Because
        # outside code subscribes to events published by the use case, not by
        # this. Oops.
        def initialize(broadcast:)
          @broadcast = broadcast
        end

        def call
          load_article_list
        end

        def all_articles(articles)
          @articles = articles
          self
        end

        private

        attr_reader :broadcast

        def load_article_list
          Wisper.subscribe(self) { broadcast.call :query_all_articles }
          self
        end
      end # class Prolog::UseCases::SummariseContent::ArticleLister
    end # class Prolog::UseCases::SummariseContent
  end
end
