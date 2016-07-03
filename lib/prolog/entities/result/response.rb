# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module Entities
    module Result
      # Encapsulates result of an action where an Author of an Article has
      # Accepted or Rejected a Contribution that has been Proposed against it.
      class Response < Dry::Types::Value
        attribute :entity, Types::Class # Accepted-Contribution entity
        attribute :errors, Types::ErrorArray
        attribute :original_content, Types::Strict::String
        attribute :proposal, Types::Class
        attribute :response, Types::ContributionResponse

        def accepted?
          response == :accepted
        end

        def rejected?
          response == :rejected
        end

        def responded?
          true
        end

        def success?
          errors.empty?
        end

        # def to_h
        #   super.merge(success: success?)
        # end
      end # class Prolog::Entities::Result::Response
    end
  end
end
