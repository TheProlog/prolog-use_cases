
require 'ox'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      attr_reader :content, :wrap_with

      def initialize(wrap_with: :div)
        @wrap_with = wrap_with
        self
      end

      def call(content:)
        @content_in = content
        @content = Ox.dump(outer_container)
        self
      end

      private

      # Reek thinks this smells of :reek:FeatureEnvy because it doesn't know
      # how blocks work? :disappointed:
      def outer_container
        Ox::Element.new(wrap_with).tap do |container|
          container[:id] = 'body-content'
          container['data-contribution-counter'] = 0
        end
      end
    end # class Prolog::Services::MarkdownToHtml
  end
end
