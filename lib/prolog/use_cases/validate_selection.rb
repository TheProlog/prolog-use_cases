
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
