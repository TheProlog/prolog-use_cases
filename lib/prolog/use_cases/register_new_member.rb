# frozen_string_literal: true

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
        init_form_object(params)
        return :precondition_failed unless all_preconditions_met?
        add_new_entity_for(params)
      end

      private

      attr_reader :authoriser, :form_object, :repository

      def add_new_entity_for(params)
        repository.add new_entity(params)
      end

      def all_preconditions_met?
        current_user_is_permitted? && validate_params && name_available?
      end

      def current_user_is_permitted?
        return true if authoriser.guest?
        notifications[:failure] = [:already_logged_in]
        false
      end

      def init_form_object(params)
        @form_object = FormObject.new(params)
        @form_object.valid?
      end

      def name_available?
        !named_user.respond_to? :name
      end

      def named_user
        repository.find(name: form_object.name)
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
