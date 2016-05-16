# frozen_string_literal: true

require 'forwardable'

require_relative './body_marker'

# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Wrap contributionn target in content with marker tag pairs. This needs
      # to "return" an entity with `:argicle`, `:endpoints`, and
      # `:proposed_content` attributes, *but not* `:id_number`
      class WrapContribution
        extend Forwardable

        def self.call(attributes:, id_number:)
          params = { attributes: attributes, id_number: id_number }
          WrapContribution.new(params).call
        end

        def call
          new_article_with body_with_markers
        end

        protected

        def initialize(attributes:, id_number:)
          @id_number = id_number
          @attributes = attributes
          self
        end

        private

        attr_reader :id_number

        def_delegators :@attributes, :article, :endpoints, :proposed_content

        def body_with_markers
          BodyMarker.new(bwm_params).to_s
        end

        def bwm_params
          { body: article.body, endpoints: endpoints, id_number: id_number }
        end

        def new_article(attribs)
          article.class.new(*attribs.values)
        end

        def new_article_with(new_body)
          attribs = article.to_h
          attribs[:body] = new_body
          new_article(attribs)
        end
      end # class Prolog::UseCases::ProposeEditContribution::WrapContribution
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
