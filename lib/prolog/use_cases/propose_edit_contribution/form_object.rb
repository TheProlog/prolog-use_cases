# frozen_string_literal: true

require 'forwardable'

# Hack to use Rails' broken :delegate rather than the standard library's.
# Yes, this is obscene. Not least because it must be done *once and only once*,
# at the *first* relevant leaf node of the required source tree. :rage:
module Forwardable
  remove_method :delegate if Forwardable.respond_to?(:delegate)
end

require 'active_model'
require 'virtus'

require 'prolog/support/form_object/integer_range'

require_relative './body_marker'

module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Form object for data validation and organisation.
      class FormObject
        include Virtus.value_object
        include ActiveModel::Validations
        include Prolog::Support::FormObject
        extend Forwardable

        values do
          attribute :article, Object # formerly Prolog::Core::Article
          attribute :endpoints, IntegerRange
          attribute :proposed_content, String
        end

        # def_delegators :authoriser, :guest?, :user_name

        def initialize(**params)
          @pcv = nil
          @wrapped = false
          super
        end

        # The only "command" method in the class. Given an ID number and an
        # otherwise-correctly-populated set of attributes, modifies the article
        # content, wrapping identified anchor tag pairs around the range of
        # content specified by the endpoint values (which are not otherwise
        # checked). Responsibility is *ON THE CALLER* to ensure that everything
        # is valid. Since this is memoised, after a fashion, screwups can be
        # rectified only by creating a new instance of this class. YHBW.
        def wrap_contribution_with(id_number)
          return self if !valid? || @wrapped
          article.body = body_with_markers(id_number)
          @wrapped = true
          self
        end

        private

        # Primary worker.

        def body_with_markers(id_number)
          BodyMarker.new(bwm_params id_number).to_s
        end

        # Support methods for the above; extract as sensible.

        # ... for `#body_with_markers`; gets article/endpoints dependencies out
        #     of the way. No supporting methods of its own.

        def bwm_params(id_number)
          { body: article.body, endpoints: endpoints, id_number: id_number }
        end
      end # class Prolog::UseCases::ProposeEditContribution::FormObject
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
