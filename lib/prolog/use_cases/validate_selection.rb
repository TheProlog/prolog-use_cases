# frozen_string_literal: true

require_relative 'validate_selection/form_object'

module Prolog
  module UseCases
    # Validate selection parameters for eventual Contribution proposal.
    class ValidateSelection
      extend Forwardable

      def_delegators :form_object, :errors, :invalid?, :valid?

      attr_reader :result

      def initialize(**params)
        @result = :validation_failed # until proven otherwise
        update_attributes_with params
        self
      end

      def call(**params)
        update_attributes_with params
      end

      private

      attr_reader :form_object

      def attributes_including(params)
        existing = form_object ? form_object.to_hash : {}
        existing.merge params
      end

      def update_attributes_with(params)
        @form_object = FormObject.new attributes_including(params)
        update_result
      end

      def update_result
        ret = form_object.valid?
        @result = ret ? form_object.article : :validation_failed
        ret
      end
    end # class Prolog::UseCases::ValidateSelection
  end
end
