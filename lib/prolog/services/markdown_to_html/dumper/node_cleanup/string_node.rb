
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
            # Perform position-based transform ("change") of string value.
            class Transformer
              def self.call(str, position)
                str.send _transforms[position]
              end

              def self._transforms
                {
                  initial: :lstrip,
                  intermediate: :to_s,
                  terminal: :rstrip,
                  only: :strip
                }
              end
            end # class ...::Dumper::NodeCleanup::StringNode::Transformer

            def initialize(string:, position:)
              @string = string
              @position = position
              self
            end

            def to_s
              initial_string.gsub(regex, ' ').gsub(/\s+/, ' ')
            end

            private

            attr_reader :position, :string

            def initial_string
              Transformer.call string, position
            end

            def regex
              return /\s+/ unless position == :initial
              /\s+$/
            end
          end # class ...::MarkdownToHtml::Dumper::NodeCleanup::StringNode
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # Prolog::Services::MarkdownToHtml
  end
end
