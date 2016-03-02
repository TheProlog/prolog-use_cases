
require 'forwardable'

# require_relative 'content_selection/form_object'

module Prolog
  module Services
    # Encapsulates logic for extracting a section of content from an Article
    # body.
    class ContentSelection
      # Wraps identified anchor pairs around endpoint-defined selection.
      class UpdatedBody
        def initialize(form_obj, anchor_format)
          @form_obj = form_obj
          @anchor_format = anchor_format
        end

        def to_s
          return article_body unless valid?
          parts.join
        end

        alias_method :to_str, :to_s

        delegate :article, :endpoints, :errors, :last_contribution_id,
                 :selected_markup, :valid?, to: :@form_obj

        private

        attr_reader :anchor_format

        def anchor_for(which_end)
          format anchor_format, which_end
        end

        def article_body
          article.body
        end

        def begin_endpoint
          endpoints.begin
        end

        def end_endpoint
          endpoints.end
        end

        def leading_content
          article_body[0...begin_endpoint]
        end

        def parts
          [leading_content, anchor_for(:begin), selected_markup,
           anchor_for(:end), trailing_content]
        end

        def trailing_content
          article_body[end_endpoint..-1]
        end
      end # class Prolog::Services::ContentSelection::UpdatedBody
    end # class Prolog::Services::ContentSelection
  end
end
