
require_relative 'renderer/html_pipeline_converter'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Actually renders Markdown content as (non-compact) HTML.
      class Renderer
        private_constant :HtmlPipelineConverter

        def initialize(content:)
          @rendered = HtmlPipelineConverter.render content
          self
        end

        def to_s
          @rendered
        end

        alias_method :to_str, :to_s
      end # class Prolog::Services::MarkdownToHtml::Renderer
    end # class Prolog::Services::MarkdownToHtml
  end
end
