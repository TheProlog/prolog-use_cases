
require_relative 'markdown_to_html/container_node'
require_relative 'markdown_to_html/dumper'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      def self.call(content:)
        Renderer.new(content: content).to_s
      end
    end # class Prolog::Services::MarkdownToHtml
  end
end
