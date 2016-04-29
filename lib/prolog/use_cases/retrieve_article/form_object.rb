# frozen_string_literal: true

require 'active_model'
require 'virtus'

require_relative 'form_object/article_matcher'

module Prolog
  module UseCases
    # Retrieve a single Article, based on search terms
    class RetrieveArticle
      # Form object for all your data validation and massaging needs. :grinning:
      class FormObject
        include Virtus.value_object
        include ActiveModel::Validations

        values do
          attribute :current_user, String
          attribute :author_name, String,
                    default: -> (fo, _) { fo.current_user }
          attribute :title, String
          attribute :body, String
          attribute :image_url, String
          attribute :repository, Object
          # FIXME: No keywords yet...
        end

        def article
          if_valid_repository { match_article }
        end

        private

        def if_valid_repository
          return :invalid_repository unless repository?
          yield
        end

        def match_article
          ArticleMatcher.call { query_repository }
        end

        def query_repository
          repository.find attributes
        end

        def repository?
          repository.respond_to? :find
        end
      end # class Prolog::UseCases::RetrieveArticle::FormObject
    end # class Prolog::UseCases::RetrieveArticle
  end
end
