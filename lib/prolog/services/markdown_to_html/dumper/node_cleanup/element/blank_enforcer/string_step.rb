
module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Dump Ox node tree to flattened HTML string (no intervening whitespace).
      class Dumper
        # Enforces whitespace conventions in nodes and text strings
        class NodeCleanup
          # Top-level class to clean a single HTML element string (possibly
          # including child elements) so that its textual representation
          # complies with our whitespae conventions.
          class Element
            # Enforce policy that all string content (below an instance of
            # `Ox::Node`) has no whitespace characters other than a space, and
            # that no occurrences of multiple consecutive spaces exist.
            class BlankEnforcer
              # What should happen to a String child of a parent node?
              class StringStep
                def self.call(string)
                  _trim_multiple_spaces(_trim_non_spaces string)
                end

                def self._trim_multiple_spaces(string)
                  string.gsub(/ {2,}/, ' ')
                end

                def self._trim_non_spaces(string)
                  string.gsub(/[\t\r\n\f\v]/, ' ')
                end
              end # class ..::NodeCleanup::Element::BlankEnforcer::StringStep
            end # class ..::Dumper::NodeCleanup::Element::BlankEnforcer
          end # class ...::MarkdownToHtml::Dumper::NodeCleanup::Element
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # class Prolog::Services::MarkdownToHtml
  end
end
