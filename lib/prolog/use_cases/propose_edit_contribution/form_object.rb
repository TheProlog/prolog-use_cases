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

require 'prolog/entities/edit_contribution/proposed'
require 'prolog/support/form_object/integer_range'

require_relative 'form_object/body_marker'
require_relative 'form_object/proposed_content_validator'

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
          attribute :authoriser, Object
          attribute :article, Object # formerly Prolog::Core::Article
          attribute :endpoints, IntegerRange
          attribute :proposed_content, String
          attribute :justification, String

          attribute :proposed_at, DateTime, default: -> (_, _) { DateTime.now }
          attribute :article_id, Prolog::Entities::ArticleIdent,
                    default: -> (fo, _) { default_article_id(fo) },
                    writer: :private
          attribute :status, Symbol, default: -> (fo, _) { default_status(fo) },
                                     writer: :private
        end

        delegate :guest?, :user_name, to: :authoriser
        validate :logged_in?, :valid_proposed_content?

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

        # Since all error messages, regardless of field, are JSON payloads,
        # reading all error messages, regardless of field, as a unified array
        # fits well with our current metaphor for UI gateway notifications.
        def all_error_messages
          errors.messages.values.flatten
        end

        # Populates default/only `:article_id` attribute value.
        def self.default_article_id(fo)
          article = fo.article
          attribs = { author_name: article.author_name, title: article.title }
          Prolog::Entities::ArticleIdent.new attribs
        end

        # Populates default/only `:status` attribute value.
        def self.default_status(fo)
          return :accepted if fo._proposed_by_author?
          :proposed
        end

        # This is a public method only because it's called by `.default_status`
        # using its FormObject parameter instance. It *SHOULD NOT* be called
        # directly by the containing class' (or other) code.
        def _proposed_by_author?
          user_name == article.author_name
        end

        private

        # Primary worker.

        def body_with_markers(id_number)
          BodyMarker.new(bwm_params id_number).to_s
        end

        # Direct validation methods

        def logged_in?
          return true unless guest?
          errors.add :authoriser, not_logged_in_failure_message
          false
        end

        def report_invalid_proposed_content
          errors.add :proposed_content, validator.payload
          false
        end

        def valid_proposed_content?
          validator.valid? || report_invalid_proposed_content
        end

        def validator
          return @pcv if @pcv
          @pcv = ProposedContentValidator.new article_id: article_id,
                                              proposed_content: proposed_content
        end

        # Support methods for the above; extract as sensible.

        # ... for `#body_with_markers`; gets article/endpoints dependencies out
        #     of the way. No supporting methods of its own.

        def bwm_params(id_number)
          { body: article.body, endpoints: endpoints, id_number: id_number }
        end

        # ... for `#logged_in?`; builds JSON payload using `article_id`. No
        #     supporting methods of its own.

        def not_logged_in_failure_message
          { failure: 'not logged in', article_id: article_id }.to_json
        end
      end # class Prolog::UseCases::ProposeEditContribution::FormObject
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
