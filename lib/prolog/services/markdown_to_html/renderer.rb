
require 'motion-markdown-it'
require 'ox'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Actually renders Markdown content as (non-compact) HTML.
      class Renderer
        def initialize(content:)
          @content = content
          self
        end

        def to_s
          nodes.map { |node| Ox.dump(node).strip }.join
        end

        private

        attr_reader :content

        def nodes
          # Ox *must* parse a (local) root element to see its children
          Ox.parse(['<div>', '</div>'].join parsed_content).nodes
        end

        def parsed_content
          parser.render content
        end

        def parser
          @parser ||= MarkdownIt::Parser.new(parser_opts)
        end

        def parser_opts
          { html: true, xhtmlOut: true }
        end
      end # class Prolog::Services::MarkdownToHtml::Renderer
    end # class Prolog::Services::MarkdownToHtml
  end
end
