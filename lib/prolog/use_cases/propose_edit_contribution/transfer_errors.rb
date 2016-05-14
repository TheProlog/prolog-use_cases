# frozen_string_literal: true

# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Reports validator uerrors to the UI gateway as failures.
      class TransferErrors
        def self.call(attributes:, ui_gateway:)
          TransferErrors.new(attributes, ui_gateway).call
        end

        def call
          errors.each { |payload| ui_gateway.failure payload }
          self
        end

        protected

        def initialize(attributes, ui_gateway)
          @errors = Internals.errors_from_attributes(attributes)
          @ui_gateway = ui_gateway
          self
        end

        private

        attr_reader :errors, :ui_gateway

        # Methods that neither affect nor depend on instance state.
        module Internals
          def self.errors_from_attributes(attributes)
            ValidateAttributes.new.call(attributes).errors.values
          end
        end
        private_constant :Internals
      end # class Prolog::UseCases::ProposeEditContribution::TransferErrors
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
