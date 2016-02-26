
require_relative 'content_node'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Converts content to an Ox node wrapped in an outer container, e.g., div.
      class ContainerNode
        def initialize(content:, wrap_with:)
          @content = content
          @wrap_with = wrap_with
          self
        end

        def to_node
          outer_container << content_node
        end

        private

        attr_reader :content, :wrap_with

        def content_node
          ContentNode.new(content: content).to_node
        end

        # Reek thinks this smells of :reek:FeatureEnvy because it doesn't know
        # how blocks work? :disappointed:
        def outer_container
          wrapper_element.tap do |container|
            container[:id] = 'body-content'
            container['data-contribution-counter'] = 0
          end
        end

        def wrapper_element
          Ox::Element.new(wrap_with)
        end
      end # class Prolog::Services::MarkdownToHtml::ContainerNode
    end # class Prolog::Services::MarkdownToHtml
  end
end
