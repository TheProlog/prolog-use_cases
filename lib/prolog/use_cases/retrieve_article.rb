# frozen_string_literal: true

require 'prolog/core'

require_relative 'retrieve_article/form_object'

module Prolog
  module UseCases
    # Retrieve a single Article, based on search terms
    class RetrieveArticle
      def initialize(repository:, authoriser:)
        @repository = repository
        @authoriser = authoriser
        self
      end

      def call(**params)
        actual_params = actual_params_for params
        FormObject.new(actual_params).article
      end

      private

      attr_reader :authoriser, :repository

      def actual_params_for(params)
        { current_user: authoriser.current_user }.merge params
      end
    end # class Prolog::UseCases::RetrieveArticle
  end
end
