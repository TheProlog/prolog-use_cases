
require 'active_model'
require 'virtus'

require 'prolog/entities/edit_contribution/proposed'
require 'prolog/support/form_object/integer_range'

require_relative 'form_object/body_marker'

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

        def body_with_markers(id_number)
          marker = BodyMarker.new body: article.body, endpoints: endpoints,
                                  id_number: id_number
          marker.to_s
        end

        def proposed_by_author?
          user_name == article.author_name
        end

        def wrap_contribution_with(id_number)
          return self if @wrapped
          article.body = body_with_markers(id_number)
          @wrapped = true
          self
        end

        def self.default_article_id(fo)
          article = fo.article
          attribs = { author_name: article.author_name, title: article.title }
          Prolog::Entities::ArticleIdent.new attribs
        end

        def self.default_status(fo)
          return :accepted if fo.proposed_by_author?
          :proposed
        end
      end # class Prolog::UseCases::ProposeEditContribution::FormObject
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
