
module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Dump Ox node tree to flattened HTML string (no intervening whitespace).
      class Dumper
        # Enforces whitespace conventions in nodes and text strings
        class NodeCleanup
          # Basic string-cleanup policy enforcement for strings within elements.
          class StringNode
            def initialize(string:, position:)
              @string = string
              @position = position
              self
            end

            def to_s
              initial_string.gsub(regex, ' ')
            end

            private

            attr_reader :position, :string

            def initial_string
              return transform.call(string) if transform
              fail "Invalid :position value: '#{position}'"
            end

            def regex
              {
                initial: /\s+$/,
                intermediate: /\s+/,
                terminal: /\s+/
              }[position]
            end

            def transform
              transforms[position]
            end

            def transforms
              {
                initial: -> (str) { str.lstrip },
                intermediate: -> (str) { str },
                terminal: -> (str) { str.rstrip }
              }
            end
          end # class ...::MarkdownToHtml::Dumper::NodeCleanup::StringNode
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # Prolog::Services::MarkdownToHtml
  end
end
