
require 'prolog/services/replace_content'

module Prolog
  module UseCases
    # Validate selection parameters for eventual Contribution proposal.
    class ValidateSelection
      # Form object for data validation and organisation
      class FormObject
        # Builds an object that, inter alia, validates content-related proposal
        # parameters.
        class BodyReplacementValidator
          def self.build(form_obj)
            params = _params_from form_obj
            _replacer(params).tap(&:convert)
          end

          def self._params_from(fo)
            { content: fo.article&.body.to_s, endpoints: fo.endpoints,
              replacement: fo.replacement_content.to_s }
          end

          def self._replacer(params)
            Prolog::Services::ReplaceContent.new(params)
          end
        end # class ...::ValidateSelection::FormObject::BodyReplacementValidator
      end # class Prolog::UseCases::ValidateSelection::FormObject
    end # class Prolog::UseCases::ValidateSelection
  end
end
