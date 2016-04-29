# frozen_string_literal: true

require 'uri'

require 'active_model'
require 'virtus'

module Prolog
  module UseCases
    # Encapsulates domain logic for publishing (persisting) a new Article
    # FIXME: This class smells of :reek:TooManyInstanceVariables
    class PublishNewArticle
      # Form object for all your data validation and massaging needs. :grinning:
      class FormObject
        # Walk an ActiveModel::Validation::Errors instance for unique messages.
        class UniqueErrors
          attr_reader :store

          def initialize
            @store = Hash.new([])
            self
          end

          def call(errors)
            errors.messages.each { |key, messages| store[key] = messages.uniq }
            self
          end
        end # class ...::UseCases::PublishNewArticle::FormObject::UniqueErrors

        # Virtus attribute to clean up keyword strings before persistence
        class KeywordList < Virtus::Attribute
          def coerce(value)
            Array(value).map { |item| item.to_s.strip.gsub(/\s+/, ' ') }
          end
        end

        private_constant :KeywordList, :UniqueErrors

        include Virtus.value_object
        include ActiveModel::Validations

        values do
          attribute :title, String
          attribute :body, String
          attribute :image_url, String
          attribute :author_name, String
          attribute :keywords, KeywordList
          attribute :current_user, String, writer: :private
        end

        validates :title, format: { with: /\A\S.*\S\z/ }
        validates :title, format: { without: /\s{2,}/ }
        validate :author_is_current_user
        validate :body_or_image_url_must_exist

        def error_notifications
          valid?
          return {} if valid?
          unique_errors
        end

        private

        def unique_errors
          UniqueErrors.new.call(errors).store
        end

        def author_is_current_user
          return if author_name == current_user
          errors.add :author_name, 'not current user'
        end

        def body_or_image_url_must_exist
          if_invalid_image_url { report_if_body_also_empty }
        end

        def if_invalid_image_url
          @body = body.to_s.strip
          yield unless image_url_is_valid?
        end

        def report_if_body_also_empty
          @image_url = ''
          return unless body.empty?
          errors.add :image_url, 'is not valid; it or body content must be'
        end

        def image_url_is_valid?
          uri = URI.parse(image_url)
          return %w(http https).include?(uri.scheme)
        rescue URI::InvalidURIError
          false
        end
      end # class Prolog::UseCases::PublishNewArticle::FormObject
    end # class Prolog::UseCases::PublishNewArticle
  end
end
