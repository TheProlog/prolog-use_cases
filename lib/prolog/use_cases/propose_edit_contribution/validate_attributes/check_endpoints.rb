# frozen_string_literal: true
# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Validates value attributes sent to `ProposeEditContribution#call`.
      class ValidateAttributes
        # Simple cclass to check if specified endpoints define a valid range
        # within the specified article-body content.
        class CheckEndpoints
          def self.call(article_body:, article_id:, endpoints:)
            CheckEndpoints.new(article_body, endpoints, article_id).call
          end

          def call
            return [] if valid_selection?
            JSON.dump(error_data)
          end

          protected

          def initialize(article_body, endpoints, article_id)
            @article_body = article_body
            @endpoints = endpoints
            @article_id = article_id
            self
          end

          private

          attr_reader :article_body, :article_id, :endpoints

          def error_data
            { article_id: YAML.dump(article_id.to_h),
              failure: 'invalid endpoints' }
          end

          def valid_selection?
            article_body[endpoints]
          end
        end # class ...::ValidateAttributes::CheckEndpoints
      end # class Prolog::UseCases::ProposeEditContribution::ValidateAttributes
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
