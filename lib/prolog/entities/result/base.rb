# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module Entities
    module Result
      # Common bits in (virtually) any `Result` value object: `:errors`
      # attribute; success/failure test sugar; hash conversion.
      class Base < Dry::Types::Value
        attribute :errors, Types::ErrorArray

        def success?
          errors.empty?
        end

        def failure?
          !success?
        end

        # def to_h
        #   super.merge(success?: success?)
        # end
      end # class Prolog::Entities::Result::Response
    end
  end
end
