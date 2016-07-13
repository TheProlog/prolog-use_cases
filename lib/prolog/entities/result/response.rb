# frozen_string_literal: true

require 'prolog/entities/result/base'

module Prolog
  module Entities
    module Result
      # Encapsulates result of an action where an Author of an Article has
      # Accepted or Rejected a Contribution that has been Proposed against it.
      class Response < Base
        attribute :entity, Types::Class # Contribution entity
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
      end # class Prolog::Entities::Result::Response
    end
  end
end
