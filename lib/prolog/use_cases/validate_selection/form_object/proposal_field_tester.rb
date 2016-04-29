# frozen_string_literal: true

require_relative './body_replacement_validator'

module Prolog
  module UseCases
    # Validate selection parameters for eventual Contribution proposal.
    class ValidateSelection
      # Form object for data validation and organisation
      class FormObject
        # Reports if proposal params are invalid due to a specific parameter.
        class ProposalFieldTester
          def self.accepts?(fo, key)
            !_validator(fo).errors.key?(key)
          end

          def self._validator(obj)
            BodyReplacementValidator.build(obj).tap(&:valid?)
          end
        end # class ...::ValidateSelection::FormObject::ProposalFieldTester
      end # class Prolog::UseCases::ValidateSelection::FormObject
    end # class Prolog::UseCases::ValidateSelection
  end
end
