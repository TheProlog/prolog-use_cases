
require 'active_model'
require 'validates_email_format_of'
require 'virtus'

module Prolog
  module UseCases
    # Encapsulates domain logic for registration of new member.
    class RegisterNewMember
      # Form object for all your data validation and massaging needs. :grinning:
      class FormObject
        include Virtus.model
        include ActiveModel::Validations

        attribute :name, String
        attribute :email, String
        attribute :profile, String
        attribute :password, String
        attribute :password_confirmation, String

        validates :name, format: { with: /\A([[:alpha:]][\.\- \w]{4,}\w)\z/ }
        validates :name, format: { without: /\s{2,}/ }
        validate :validate_email
        validates :password, confirmation: true, length: { minimum: 8 }
        validates :password_confirmation, presence: true

        # This method smells of :reek:DuplicateMethodCall; errors.messages 2x
        def error_notifications
          valid?
          return {} if valid?
          unique_errors
        end

        private

        def unique_errors
          ret = {}
          errors.messages.each { |key, messages| ret[key] = messages.uniq }
          ret
        end

        def validate_email
          email_errors = ValidatesEmailFormatOf.validate_email_format(email)
          return unless email_errors
          errors.add :email, email_errors.first
        end
      end # class Prolog::UseCases::RegisterNewMember::FormObject
    end # class Prolog::UseCases::RegisterNewMember
  end
end
