
require 'ox'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Dump Ox node tree to flattened HTML string (no intervening whitespace).
      class Dumper
        # Enforces whitespace conventions in nodes and text strings
        class NodeCleanup
          # Cleans up a string node that is the last child node of its parent.
          class TrailingStringNode
            def initialize(string:)
              @string = string
            end

            def to_s
              string.rstrip.gsub(/\s+$/, ' ')
            end

            private

            attr_reader :string
          end # class ...::Dumper::NodeCleanup::TrailingStringNode
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # Prolog::Services::MarkdownToHtml
  end
end
