
require 'active_model'
require 'virtus'

require 'prolog/entities/edit_contribution/proposed'
require 'prolog/support/form_object/integer_range'

module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Form object for data validation and organisation.
      class FormObject
        include Virtus.model
        include ActiveModel::Validations
        include Prolog::Support::FormObject

        attribute :guest, Boolean, default: true
        attribute :user_name, String, default: 'Guest User'
        attribute :article, Object # formerly Prolog::Core::Article
        attribute :endpoints, IntegerRange
        attribute :proposed_content, String
        attribute :justification, String
        attribute :proposed_at, DateTime, default: -> (_, _) { DateTime.now }
        attribute :article_id, Prolog::Entities::ArticleIdent,
                  default: -> (fo, _) { default_article_id(fo) },
                  writer: :private
        attribute :status, Symbol, default: -> (fo, _) { default_status(fo) },
                                   writer: :private

        def self.default_article_id(fo)
          article = fo.article
          attribs = { author_name: article.author_name, title: article.title }
          Prolog::Entities::ArticleIdent.new attribs
        end

        def self.default_status(fo)
          is_author = fo.user_name == fo.article.author_name
          return :proposed unless is_author
          :accepted
        end
      end # class Prolog::UseCases::ProposeEditContribution::FormObject
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
