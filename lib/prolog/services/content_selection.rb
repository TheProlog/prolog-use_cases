
require 'forwardable'

require_relative 'content_selection/form_object'

module Prolog
  module Services
    # Encapsulates logic for extracting a section of content from an Article
    # body.
    class ContentSelection
      delegate :errors, :last_contribution_id, :selected_markup, :valid?,
               to: :@form_obj

      def initialize
        @form_obj = FormObject.new last_contribution_id: 0, endpoints: (-1..-1)
        self
      end

      def call(**params)
        @form_obj = FormObject.new params
        form_obj.valid?
        self
      end

      private

      attr_reader :form_obj
    end # class Prolog::Services::ContentSelection
  end
end
