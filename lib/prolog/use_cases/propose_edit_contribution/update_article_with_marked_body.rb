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
        def self.call(attributes:, contribution_repo:)
          UpdateAttributesWithMarkedBody.new(attributes, contribution_repo).call
        end

        def call
          attributes.class.new updated_attributes
        end

        protected

        def initialize(attributes, contribution_repo)
          @attributes = attributes
          @contribution_repo = contribution_repo
          self
        end

        private

        attr_reader :attributes, :contribution_repo

        def next_sequence_from_repo
          contribution_repo.count + 1
        end

        def update_attributes_with(article)
          attribs = attributes.to_h
          attribs[:article] = article
          attribs
        end

        def updated_article
          WrapContribution.call id_number: next_sequence_from_repo,
                                attributes: attributes
        end

        def updated_attributes
          update_attributes_with updated_article
        end
      end # class ...::ProposeEditContribution::UpdateAttributesWithMarkedBody
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
