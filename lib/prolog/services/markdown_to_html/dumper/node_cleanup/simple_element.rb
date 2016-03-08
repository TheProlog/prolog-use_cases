
require 'ox'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Dump Ox node tree to flattened HTML string (no intervening whitespace).
      class Dumper
        # Enforces whitespace conventions in nodes and text strings
        class NodeCleanup
          # Produces markup for a simple element w/o child elements.
          class SimpleElement
            def initialize(node:)
              @node = node
              self
            end

            def to_s
              dump.strip
            end

            private

            attr_reader :node

            def cleanup_text
              return self if void_element?
              node.replace_text replacement_text
              self
            end

            def dump
              cleanup_text
              Ox.dump node, indent: -1
            end

            def replacement_text
              ret = node.text.to_s.strip
              return ret unless ret.empty?
              ' '
            end

            def void_element?
              # The following HTML tags are explicitly not supported by us, and
              # will almost certainly cause the rendered markup to be different
              # than the user expects, without any other lasting impact.
              #  %w(area base command embed link param source)
              %w(br col hr img input).include? node.name
            end
          end # class ...::MarkdownToHtml::Dumper::NodeCleanup::SimpleElement
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # class Prolog::Services::MarkdownToHtml
  end
end
