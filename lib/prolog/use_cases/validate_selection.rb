# frozen_string_literal: true

require_relative 'validate_selection/form_object'

unless ENV['BUNDLE_GEMFILE']
  # Hack to use Rails' broken :delegate rather than the standard library's.
  # Yes, this is obscene. Not least because we have to do this when we're
  # running individual unit tests via `ruby -Itest test_name.rb` from the
  # command line, but *not* when we're running from inside a Rake task. Blech.
  module Forwardable
    remove_method :delegate
  end
end

module Prolog
  module UseCases
    # Validate selection parameters for eventual Contribution proposal.
    class ValidateSelection
      extend Forwardable
      delegate :invalid?, :valid?, :errors, to: :form_object

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

      def update_attributes_with(params)
        attrib_hash = form_object ? form_object.to_hash : {}
        @form_object = FormObject.new attrib_hash.merge(params)
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
