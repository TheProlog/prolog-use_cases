# frozen_string_literal: true

require 'prolog/core'

require_relative 'publish_new_article/form_object'

module Prolog
  module UseCases
    # Encapsulates domain logic for publishing (persisting) a new Article
    # FIXME: This class smells of :reek:TooManyInstanceVariables
    class PublishNewArticle
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
        repository.save article
      end

      private

      attr_reader :authoriser, :params, :repository

      def all_preconditions_met?
        logged_in? && validate_params
      end

      def article
        Prolog::Core::Article.new form_object
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
