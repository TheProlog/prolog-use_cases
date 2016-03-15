
require 'ox'

require_relative 'dumper/node_cleanup'

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
          dump.strip
        end

        private

        attr_reader :node

        def dump
          NodeCleanup.new.cleanup nodes: [node]
          Ox.dump(node, indent: -1)
        end
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # class Prolog::Services::MarkdownToHtml
  end
end
