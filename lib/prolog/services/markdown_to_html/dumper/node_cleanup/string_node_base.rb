
module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Dump Ox node tree to flattened HTML string (no intervening whitespace).
      class Dumper
        # Enforces whitespace conventions in nodes and text strings
        class NodeCleanup
          # Basic string-cleanup policy enforcement for strings within elements.
          class StringNodeBase
            def initialize(string:, regex:, strip_if_end:)
              @string = string
              @regex = regex
              @strip_if_end = strip_if_end
              self
            end

            def to_s
              initial_string.gsub(regex, ' ')
            end

            private

            attr_reader :regex, :strip_if_end, :string

            def initial_string
              return transform.call(string) if transform
              fail "Invalid :strip_if_end value: '#{strip_if_end}'"
            end

            def transform
              transforms[strip_if_end]
            end

            def transforms
              {
                leading: -> (str) { str.lstrip },
                trailing: -> (str) { str.rstrip },
                neither: -> (str) { str }
              }
            end
          end # class ...::MarkdownToHtml::Dumper::NodeCleanup::StringNodeBase
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # Prolog::Services::MarkdownToHtml
  end
end
