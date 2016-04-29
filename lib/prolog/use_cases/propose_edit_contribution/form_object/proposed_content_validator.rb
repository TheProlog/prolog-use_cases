
require 'json'

module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Form object for data validation and organisation.
      class FormObject
        # Validattes proposed content as being neither nil, empty, or blank.
        class ProposedContentValidator
          def initialize(proposed_content:, article_id:)
            @proposed_content = proposed_content
            @article_id = article_id
            self
          end

          def valid?
            !proposed_content.to_s.strip.empty?
          end

          def payload
            { article_id: article_id }.tap do |ret|
              ret[:failure] = failure_message
            end.to_json
          end

          private

          attr_reader :article_id, :proposed_content

          def failure_message
            [invalid_reason, 'proposed content'].join(' ')
          end

          def invalid_reason
            reason = POSSIBLE_REASONS.detect do |_, func|
              func.call proposed_content
            end
            # Enumerable#detect returns an array, not a Hash. No worries...
            reason.first
          end

          POSSIBLE_REASONS = {
            # NOT .empty?; nil OK here
            'empty': -> (content) { content == '' },
            # Content was nil
            'missing': -> (content) { content.to_s.empty? },
            'blank': -> (content) { content.strip == '' },
            # fall-through default
            'should be valid': -> (_) { true }
          }.freeze
        end # class ...::FormObject::ProposedContentValidator
      end # class Prolog::UseCases::ProposeEditContribution::FormObject
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
