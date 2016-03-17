
require 'active_model'
require 'virtus'

require 'prolog/core'
require 'prolog/support/form_object/integer_range'

module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Form object for data validation and organisation.
      class FormObject
        include Virtus.model
        include ActiveModel::Validations
        include Prolog::Support::FormObject

        attribute :guest, Boolean, default: true
        attribute :article, Prolog::Core::Article
        attribute :endpoints, IntegerRange
        attribute :proposed_content, String
        attribute :justification, String
        attribute :proposed_content, String
      end # class Prolog::UseCases::ProposeEditContribution::FormObject
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
