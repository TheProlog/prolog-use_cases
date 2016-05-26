# frozen_string_literal: true

require_relative './wrap_contribution'

# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Creates a `ProposedEditContribution::Attributes` instance based on a
      # supplied instance, containing an  "updated" article entity with range of
      # body content marked as the subject of a Proposed Contribution.
      class UpdateAttributesWithMarkedBody
        def self.call(attributes:)
          UpdateAttributesWithMarkedBody.new(attributes).call
        end

        def call
          attributes.class.new updated_attributes
        end

        protected

        def initialize(attributes)
          @attributes = attributes
          self
        end

        private

        attr_reader :attributes

        def update_attributes_with(article)
          attribs = attributes.to_h
          attribs[:article] = article
          attribs
        end

        def updated_article
          # FIXME: We've added `contribution_id` to `attributes, but the
          # `WrapContribution` class doesn't know that yet.
          WrapContribution.call id_number: attributes.contribution_id,
                                attributes: attributes
        end

        def updated_attributes
          update_attributes_with updated_article
        end
      end # class ...::ProposeEditContribution::UpdateAttributesWithMarkedBody
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
