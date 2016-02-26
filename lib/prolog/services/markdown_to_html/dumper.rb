
require 'ox'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Dump Ox node tree to flattened HTML string (no intervening whitespace).
      class Dumper
        def initialize(node:)
          @node = node
          self
        end

        def to_s
          stripped_lines.join
        end

        private

        attr_reader :node

        def dump
          Ox.default_options = { indent: 0 }
          Ox.dump(node)
        end

        def lines
          dump.lines
        end

        def stripped_lines
          lines.map(&:strip)
        end
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # class Prolog::Services::MarkdownToHtml
  end
end
