# frozen_string_literal: true

module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Adds proposed-contribution markers to article body text.
      # Reek "thinks" 5 is :reek:TooManyInstanceVariables. Pfffft.
      class BodyMarker
        def initialize(body:, endpoints:, id_number:)
          @id_number = id_number
          @body = body
          @endpoints = endpoints
          @str = nil
          init_other_ivars
        end

        def to_s
          return @str if @str
          add_endpoint :end, end_content
          add_endpoint :begin, begin_content
          @str = @body
        end

        private

        attr_reader :endpoints, :format_str, :id_number

        def add_endpoint(which_end, content)
          index = endpoint_at which_end
          @body = insert_within_body index, content
          self
        end

        def begin_content
          format format_str, id_number, 'begin'
        end

        def end_content
          format format_str, id_number, 'end'
        end

        def endpoint_at(which_end)
          endpoints.send(which_end)
        end

        def init_other_ivars
          @str = nil
          @format_str = '<a id="contribution-%s-%s"></a>'
          self
        end

        def insert_within_body(index, content)
          @body[0...index] + content + @body[index..-1]
        end
      end # class Prolog::UseCases::ProposeEditContribution::BodyMarker
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
