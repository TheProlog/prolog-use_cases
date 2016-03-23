
require_relative 'register_new_member/form_object'

module Prolog
  module UseCases
    # Encapsulates domain logic for registration of new member.
    class RegisterNewMember
      attr_reader :notifications

      def initialize(repository:, authoriser:)
        @authoriser = authoriser
        @repository = repository
        @notifications = Hash.new([])
        self
      end

      def call(**params)
        @form_object ||= FormObject.new params
        @form_object.valid?
        return :precondition_failed unless all_preconditions_met?
        repository.add new_entity(params)
      end

      private

      attr_reader :authoriser, :form_object, :repository

      def all_preconditions_met?
        current_user_is_permitted? && validate_params && name_available?
      end

      def current_user_is_permitted?
        return true if authoriser.guest?
        notifications[:failure] = [:already_logged_in]
        false
      end

      def name_available?
        user = repository.query_user_by_name form_object.name
        user == :not_present
      end

      def new_entity(params)
        repository.create params
      end

      def validate_params
        form_object.tap { |ret| @notifications = ret.error_notifications }
      end
    end # class Prolog::UseCases::RegisterNewMember
  end
end
