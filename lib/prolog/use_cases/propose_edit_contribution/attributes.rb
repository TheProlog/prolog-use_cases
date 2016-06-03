# frozen_string_literal: true

require 'prolog/support/dry_types_setup'
require 'prolog/entities/article_ident_v'

# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Value object replacing form object as container of data items associated
      # with this use-case instance.
      class Attributes < Dry::Types::Value
        attribute :article, Types::Class
        attribute :endpoints, Types::IntegerRange
        attribute :justification, Types::Strict::String.default('')
        attribute :proposed_content, Types::Strict::String
        attribute :proposed_at, Types::DateTimeOrNow
        attribute :proposed_by, Types::Strict::String
        attribute :contribution_id, Types::UUID # generates by default

        def article_id
          Prolog::Entities::ArticleIdentV.new article_id_attribs
        end

        def status
          :proposed
        end

        def to_hash
          { status: status, article_id: article_id }.merge super
        end

        private

        def article_id_attribs
          { author_name: article.author_name, title: article.title }
        end
      end # class Prolog::useCases::ProposeEditContribution::Attributes
    end # class Prolog::useCases::ProposeEditContribution
  end
end
