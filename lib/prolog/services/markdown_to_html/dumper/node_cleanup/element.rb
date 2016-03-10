
require_relative 'element/blank_enforcer'

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
          # complies with our whitespae conventions. In summary, these are:
          # 1. Any sequence of whitespace characters within a string will be
          #    replaced by a single space;
          # 2. Any string which is the *first* child node of an element will
          #    have any leading whitespace removed;
          # 3. Any string which is the first child node of an element will have
          #    Any trailing whitespace replaced by a single space;
          # 4. Any string which is the *last* child node of an element will have
          #    any trailing whitespace removed;
          # 5. Any string which is the last child node of an element will have
          #    any leading whitespace replaced by a single space;
          # 6. Any string which is an intermediating child node of an element,
          #    i.e., which occurs between one child element of the parent
          #    element and another child element, will have any leading *or*
          #    trailing whitespace replaced by a single space.
          # 7. Any whitespace between *block level elements* (such as between
          #    two `p` elements or two `div` elements, but *not* between two
          #    `span` elements or between an `em` and `span` elements) will be
          #    removed.
          # It Would Be Very Nice If Ox (preferably) or Nokogiri could *tell* us
          # if an element is a block element or not, but we're on our own.
          class Element
            # Enforce policy that all string content (below an instance of
            # `Ox::Node`) has no whitespace characters other than a space, and
            # that no occurrences of multiple consecutive spaces exist.
            class BlankEnforcer
              # Hide internal implementation details from casual visibility.
              module Internals
                def self.all_but_spaces
                  /[\t\r\n\f\v]/
                end

                def self.each_child_node(node, &block)
                  node.nodes.each_with_index do |child, index|
                    block.call child, index
                  end
                end

                def self.step_for_string
                  lambda do |string|
                    string.gsub(all_but_spaces, ' ').gsub(/ {2,}/, ' ')
                  end
                end

                def self.step_for_node
                  -> (node) { BlankEnforcer.call node }
                end

                def self.step(child)
                  return step_for_string unless child.respond_to? :nodes
                  step_for_node
                end
              end
              private_constant :Internals

              def self.call(node)
                Internals.each_child_node(node) do |child, index|
                  node.nodes[index] = Internals.step(child).call child
                end
                node
              end
            end # class ..::Dumper::NodeCleanup::Element::BlankEnforcer

            def initialize(element:)
              @element = element
              self
            end

            def to_node
              BlankEnforcer.call element
            end

            private

            attr_reader :element
          end # class ...::MarkdownToHtml::Dumper::NodeCleanup::Element
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # class Prolog::Services::MarkdownToHtml
  end
end
