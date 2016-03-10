
require_relative 'node_step'
require_relative 'string_step'

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
              # Given a child node/string of an Element, Do The Right Thing.
              class Step
                def self.call(child_node)
                  _select(child_node).call child_node
                end

                def self._select(child_node)
                  return NodeStep if child_node.respond_to? :nodes
                  StringStep
                end
              end # class ..::Dumper::NodeCleanup::Element::BlankEnforcer::Step
            end # class ..::Dumper::NodeCleanup::Element::BlankEnforcer
          end # class ...::MarkdownToHtml::Dumper::NodeCleanup::Element
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # class Prolog::Services::MarkdownToHtml
  end
end
