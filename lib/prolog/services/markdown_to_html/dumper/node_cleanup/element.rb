
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
