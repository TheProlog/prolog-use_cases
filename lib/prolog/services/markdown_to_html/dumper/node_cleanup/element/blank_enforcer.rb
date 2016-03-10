
require_relative 'blank_enforcer/step'

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
              # Hide internal implementation details from casual visibility.
              # Reek doesn't see that this is a module, rather than a class, so
              # it complains about :reek:UtilityFunction even though these
              # methods are in a module that is extended, not included, in a
              # class. Pfffft.
              module Internals
                def each_child_node(node, &block)
                  node.nodes.each_with_index do |child, index|
                    block.call child, index
                  end
                end

                def set_child_node(node, index, child)
                  node.nodes[index] = child
                end

                def update_child_at(root_node, index, child)
                  set_child_node root_node, index, Step.call(child)
                end
              end
              private_constant :Internals
              extend Internals

              def self.call(root_node)
                each_child_node(root_node) do |child, index|
                  update_child_at root_node, index, child
                end
                root_node
              end
            end # class ..::Dumper::NodeCleanup::Element::BlankEnforcer
          end # class ...::MarkdownToHtml::Dumper::NodeCleanup::Element
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # class Prolog::Services::MarkdownToHtml
  end
end
