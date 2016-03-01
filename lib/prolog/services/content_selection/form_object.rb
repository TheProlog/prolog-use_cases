
require 'active_model'
require 'virtus'

require 'prolog/core'

require_relative 'form_object/integer_range'

module Prolog
  module Services
    # Encapsulates logic for extracting a section of content from an Article
    # body.
    class ContentSelection
      # Form object for data validation and organisation
      class FormObject
        include Virtus.model
        include ActiveModel::Validations

        attribute :article, Prolog::Core::Article
        attribute :last_contribution_id, Integer
        attribute :endpoints, IntegerRange

        validate :article?
        validate :validate_endpoints
        validate :validate_last_contribution_id

        def selected_markup
          return '' unless valid?
          selected_body_text
        end

        private

        def article?
          return true if article.instance_of?(Prolog::Core::Article)
          errors.add :article, 'invalid'
          false
        end

        def coverage
          bl_range = (0..article&.body&.length.to_i)
          endpoints.grep bl_range
        end

        def selected_body_text
          article.body[endpoints]
        end

        def valid_endpoints?
          coverage == endpoints.to_a
        end

        def validate_endpoints
          return true if article? && valid_endpoints?
          errors.add :endpoints, 'invalid'
          false
        end

        def validate_last_contribution_id
          return true if last_contribution_id
          errors.add :last_contribution_id, 'missing'
          false
        end
      end # class Prolog::Services::ContentSelection::FormObject
    end # class Prolog::Services::ContentSelection
  end
end
