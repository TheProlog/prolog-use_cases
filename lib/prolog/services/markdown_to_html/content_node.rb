
require 'ox'

require_relative 'renderer'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Converts HTML content to an Ox node (or node tree).
      class ContentNode
        def initialize(content:)
          @renderer = Renderer.new(content: content)
          self
        end

        def to_node
          Ox.parse @renderer.to_s
        end
      end # class Prolog::Services::MarkdownToHtml::ContentNode
    end # class Prolog::Services::MarkdownToHtml
  end
end
