
require_relative 'markdown_to_html/container_node'
require_relative 'markdown_to_html/dumper'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      attr_reader :content, :wrap_with

      def initialize(wrap_with: :div)
        @wrap_with = wrap_with
        self
      end

      def call(content:)
        @content = Dumper.new(node: container_node(content)).to_s
        self
      end

      private

      def container_node(content)
        ContainerNode.new(content: content, wrap_with: wrap_with).to_node
      end
    end # class Prolog::Services::MarkdownToHtml
  end
end
