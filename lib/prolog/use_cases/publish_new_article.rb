
require 'active_model'
require 'virtus'

module Prolog
  module UseCases
    # Encapsulates domain logic for publishing (persisting) a new Article
    # FIXME: This class smells of :reek:TooManyInstanceVariables
    class PublishNewArticle
      # Form object for all your data validation and massaging needs. :grinning:
      class FormObject
        include Virtus.model
        include ActiveModel::Validations

        attribute :title, String
        attribute :body, String
        attribute :image_url, String
        attribute :author_name, String
        attribute :current_user, String

        validates :title, format: { with: /\A\S.*\S\z/ }
        validates :title, format: { without: /\s{2,}/ }
        validate :body_or_image_url?
        validate :author_is_current_user?

        def error_notifications
          valid?
          return {} if valid?
          unique_errors
        end

        private

        def unique_errors
          ret = Hash.new([])
          errors.messages.each { |key, messages| ret[key] = messages.uniq }
          ret
        end

        def author_is_current_user?
          return true if author_name == current_user
          errors.add :author_name, 'not current user'
          false
        end

        def body_or_image_url?
          true
        end
      end # class Prolog::UseCases::PublishNewArticle::FormObject

      attr_reader :notifications

      def initialize(repository:, authoriser:)
        @repository = repository
        @authoriser = authoriser
        @notifications = Hash.new([])
        self
      end

      def call(**params)
        @params = params
        return :precondition_failed unless all_preconditions_met?
        :oops
      end

      private

      attr_reader :authoriser, :params, :repository

      def all_preconditions_met?
        logged_in? && validate_params
      end

      def logged_in?
        return true unless authoriser.guest?
        notifications[:current_user] = [:not_logged_in]
        false
      end

      def form_object
        @fo ||= FormObject.new form_params
      end

      def form_params
        { current_user: authoriser.current_user }.merge params
      end

      def validate_params
        @notifications = form_object.error_notifications
        form_object.valid?
      end
    end # class Prolog::UseCases::PublishNewArticle
  end
end
