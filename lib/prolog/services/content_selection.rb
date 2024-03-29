# frozen_string_literal: true

require 'forwardable'

require_relative 'content_selection/form_object'
require_relative 'content_selection/updated_body'

module Prolog
  module Services
    # Encapsulates logic for extracting a section of content from an Article
    # body.
    class ContentSelection
      extend Forwardable

      def_delegators :@form_obj, :article, :errors, :last_contribution_id,
                     :selected_markup, :valid?

      def initialize
        @form_obj = FormObject.new last_contribution_id: 0, endpoints: (-1..-1)
        update_anchor_format
        self
      end

      def call(**params)
        update_form_object params
        update_anchor_format
        update_contribution_id
        self
      end

      def updated_body
        UpdatedBody.new(form_obj, anchor_format).to_str
      end

      private

      attr_reader :anchor_format, :form_obj

      def update_anchor_format
        format = '<a id="selection-%d-%%s"></a>'
        @anchor_format = format format, last_contribution_id
        self
      end

      def update_contribution_id
        form_obj.last_contribution_id += 1 if valid?
        self
      end

      def update_form_object(**params)
        @form_obj = FormObject.new params
        valid?
        self
      end
    end # class Prolog::Services::ContentSelection
  end
end
