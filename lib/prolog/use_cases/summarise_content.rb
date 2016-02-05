
require 'prolog/core'

module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent. This includes,
    # but is not necessarily limited to, a list of most-recent articles.
    class SummariseContent
      include Wisper::Publisher

      attr_reader :articles

      def call
        query_current_user
        load_article_list
      end

      def all_articles(articles)
        @articles = articles
      end

      def current_user_is(user_name)
        @current_user_name = user_name
        self
      end

      private

      attr_reader :current_user_name

      def query_current_user
        Wisper.subscribe(self) { publish :current_user }
        self
      end

      def load_article_list
        Wisper.subscribe(self) do
          publish :all_articles_permitted_to, current_user_name
        end
        self
      end
    end # class Prolog::UseCases::SummariseContent
  end
end
