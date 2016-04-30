# frozen_string_literal: true

module Prolog
  module UseCases
    # Retrieve a single Article, based on search terms
    class RetrieveArticle
      # Form object for all your data validation and massaging needs. :grinning:
      class FormObject
        # Examines/validates a claimed Article search result.
        class ArticleMatcher
          def self.call(&block)
            if_countable(block.call) { |enum| find_article_in_enum enum }
          end

          def self.find_article_in_enum(enum)
            if_single_match(enum) do |match|
              if_article(match) { |art| art }
            end
          end

          def self.if_article(obj)
            methods = [:author_name, :body, :image_url, :keywords, :title]
            actual = methods.reject { |sym| obj.respond_to? sym }
            return :not_an_article unless actual.empty?
            obj
          end

          def self.if_countable(obj)
            return :search_failure unless obj.respond_to? :count
            yield obj
          end

          def self.if_single_match(enum)
            return :non_specific_search_terms unless enum.count == 1
            yield enum.first
          end
        end # class ...::UseCases::RetrieveArticle::FormObject::ArticleMatcher
      end # class Prolog::UseCases::RetrieveArticle::FormObject
    end # class Prolog::UseCases::RetrieveArticle
  end
end
