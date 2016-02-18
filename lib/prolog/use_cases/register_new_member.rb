
require_relative 'register_new_member/form_object'

module Prolog
  module UseCases
    # Encapsulates domain logic for registration of new member.
    # FIXME: This class smells of :reek:TooManyInstanceVariables
    class RegisterNewMember
      attr_reader :notifications

      def initialize(repository:, authoriser:)
        @authoriser = authoriser
        @repository = repository
        @notifications = Hash.new([])
        self
      end

      def call(**params)
        @params = params
        return nil unless current_user_is_permitted?
        return nil unless validate_params
        :oops
      end

      private

      attr_reader :authoriser

      def current_user_is_permitted?
        return true if authoriser.guest?
        notifications[:failure] = [:already_logged_in]
        false
      end

      def form_object
        @form_obj ||= FormObject.new @params
        @form_obj.valid?
        @form_obj
      end

      def validate_params
        form_object.tap { |ret| @notifications = ret.error_notifications }
      end
    end # class Prolog::UseCases::RegisterNewMember
  end
end
