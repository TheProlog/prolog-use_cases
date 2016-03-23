
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

        def error_notifications
          valid?
          unique_error_messages
        end

        private

        def email_errors
          ValidatesEmailFormatOf.validate_email_format(email)
        end

        def report_email_error
          errors.add :email, email_errors.first
        end

        # Why not do something simple like
        #   errors.messages.each_key { |k| errors.messages[k].uniq! }
        # Simple; we don't own `errors`, so we don't want to screw with its
        # memory management.
        def unique_error_messages
          hash = {}
          errors.keys.each { |key| hash[key] = uniques_for key }
          hash
        end

        def uniques_for(key)
          errors.messages[key].uniq
        end

        def validate_email
          report_email_error if email_errors
        end
      end # class Prolog::UseCases::RegisterNewMember::FormObject
    end # class Prolog::UseCases::RegisterNewMember
  end
end
