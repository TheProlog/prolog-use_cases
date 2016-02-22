
require 'prolog/core'

module Prolog
  module UseCases
    # Retrieve a single Article, based on search terms
    class RetrieveArticle
      # Methods that neither affect nor are affected by instance state
      module Internals
        def self.article_or_error_for(article)
          return article if article.respond_to? :image_url
          :non_specific_search_terms
        end
      end
      private_constant :Internals
      include Internals

      def initialize(repository:, authoriser:)
        @repository = repository
        @authoriser = authoriser
        self
      end

      def call(**params)
        Internals.article_or_error_for(article(params))
      end

      private

      attr_reader :authoriser, :repository

      def article(params)
        repository.where article_search_terms(params)
      end

      def article_search_terms(params_in)
        { author_name: authoriser.current_user }.merge params_in
      end
    end # class Prolog::UseCases::RetrieveArticle
  end
end
