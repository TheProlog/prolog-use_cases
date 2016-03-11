
require 'ox'

require_relative '../string_node'

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
            # Walk tree of child elements, and within each element, iterate its
            # (direct) child  nodes, enforcing position-dependent rules on
            # spacing within strings which occur within multiple child nodes of
            # a single parent node (in practice, Element). Spacing policies vary
            # depending on whether a string is an initial, intermediate, or
            # terminal child node of a parent element.
            #
            # For example, in the HTML markup
            #
            # ```html
            # <p>This is <em>emphasised</em> content.</p>
            # ```
            #
            # the string `This is ` is an `:initial` child of the `p` element;
            # the string ` content.` is a `:terminal` child of that element, and
            # the string `emphasised` is the sole child of the enclosed `em`
            # element (and will thus not be touched by this class).
            class TrimEnforcer
              def self.call(root_el)
                return root_el if _simple_element?(root_el)
                root_el.nodes.each_with_index do |original, index|
                  _update_node_for root_el, original, index
                end
                root_el
              end

              def self._simple_element?(node)
                node.nodes.count < 2
              end

              def self._update_node_for(root, child, index)
                position = _position_for_index root, index
                root.nodes[index] = _call_for_child(child).call child, position
              end

              def self._call_for_child(child)
                return method(:_call_for_node) if child.respond_to?(:nodes)
                method(:_call_for_string)
              end

              def self._call_for_node(node, _position)
                call(node)
              end

              def self._call_for_string(node, position)
                StringNode.new(string: node, position: position).to_s
              end

              # Reek doesn't like `index` being a :reek:ControlParameter.
              # We might actually care, in the far-off Mists of Time. Not now.
              def self._position_for_index(node, index)
                last_index = node.nodes.count - 1
                case index
                when 0 then :initial
                when last_index then :terminal
                else :intermediate
                end
              end
            end # class ...::Dumper::NodeCleanup::Element::TrimEnforcer
          end # class ...::MarkdownToHtml::Dumper::NodeCleanup::Element
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # class Prolog::Services::MarkdownToHtml
  end
end
