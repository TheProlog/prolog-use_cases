
require_relative 'string_node_base'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Dump Ox node tree to flattened HTML string (no intervening whitespace).
      class Dumper
        # Enforces whitespace conventions in nodes and text strings
        class NodeCleanup
          # Cleans up a string node that is neither first nor last child of its
          # parent.
          class IntermediateStringNode < StringNodeBase
            def initialize(string:)
              super string: string, strip_if_end: :neither, regex: /\s+/
            end
          end # class ...::Dumper::NodeCleanup::IntermediateStringNode
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # Prolog::Services::MarkdownToHtml
  end
end
