
require_relative 'validate_selection/form_object'

module Prolog
  module UseCases
    # Validate selection parameters for eventual Contribution proposal.
    class ValidateSelection
      extend Forwardable
      delegate :invalid?, :valid?, :errors, to: :form_object

      def initialize(**params)
        @form_object = FormObject.new params
        valid?
        self
      end

      private

      delegate :article, to: :form_object

      attr_reader :form_object
    end # class Prolog::UseCases::ValidateSelection
  end
end
