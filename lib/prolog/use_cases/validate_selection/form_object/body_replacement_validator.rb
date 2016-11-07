# frozen_string_literal: true

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
            _replace_and_convert params
          end

          # Reek complains of a :reek:NilCheck here.
          def self._article_body_from(fo)
            fo.article&.body.to_s
          end

          def self._article_replacement_content_from(fo)
            fo.replacement_content.to_s
          end

          def self._params_from(fo)
            { content: _article_body_from(fo), endpoints: fo.endpoints,
              replacement: _article_replacement_content_from(fo) }
          end

          def self._replacer(params)
            Prolog::Services::ReplaceContent.new(params)
          end

          def self._replace_and_convert(params)
            _replacer(params).tap(&:convert)
          end
        end # class ...::ValidateSelection::FormObject::BodyReplacementValidator
      end # class Prolog::UseCases::ValidateSelection::FormObject
    end # class Prolog::UseCases::ValidateSelection
  end
end
