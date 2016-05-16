# frozen_string_literal: true
# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Validates value attributes sent to `ProposeEditContribution#call`.
      class ValidateAttributes
        # Simple cclass to check if proposer is guest user, building error data
        # if so.
        class CheckContent
          def self.call(proposed_content:, article_id:)
            CheckContent.new(proposed_content, article_id).call
          end

          def call
            return [] if proposed_content?
            JSON.dump(error_data)
          end

          protected

          def initialize(proposed_content, article_id)
            @proposed_content = proposed_content
            @article_id = article_id
            self
          end

          private

          attr_reader :article_id, :proposed_content

          def error_data
            { article_id: YAML.dump(article_id.to_h),
              failure: 'empty proposed content' }
          end

          def proposed_content?
            !proposed_content.to_s.empty?
          end
        end # class ...::ValidateAttributes::CheckContent
      end # class Prolog::UseCases::ProposeEditContribution::ValidateAttributes
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
