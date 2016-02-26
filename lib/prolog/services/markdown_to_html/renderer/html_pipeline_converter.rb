
require 'html/pipeline'

module Prolog
  module Services
    # Service to convert Markdown content to equivalent HTML.
    class MarkdownToHtml
      # Actually renders Markdown content as (non-compact) HTML.
      class Renderer
        # HTML::Pipeline-based code for Markdown parsing.
        module HtmlPipelineConverter
          # Support methods, to be hidden from outside view.
          module Internals
            def self.cleanup(content)
              strip_lines_in(content).join
            end

            def self.strip_lines_in(content)
              content.lines.map(&:rstrip)
            end

            def self.context
              {
                gfm: true,
                asset_root: '/images', # for emoji
                base_url: 'https://github.com/' # for @mentions
              }
            end

            def self.filters
              [
                HTML::Pipeline::MarkdownFilter,
                HTML::Pipeline::ImageMaxWidthFilter,
                HTML::Pipeline::MentionFilter,
                HTML::Pipeline::EmojiFilter,
                # HTML::Pipeline::SyntaxHighlightFilter,
                HTML::Pipeline::AutolinkFilter
              ]
            end

            def self.pipeline
              HTML::Pipeline.new filters, context
            end
          end # module ...::Renderer::HtmlPipelineConverter::Internals
          private_constant :Internals

          def self.render(fragment)
            result = Internals.pipeline.call fragment
            Internals.cleanup result[:output]
          end
        end # module ...::MarkdownToHtml::Renderer::HtmlPipelineConverter
      end # class Prolog::Services::MarkdownToHtml::Renderer
    end # class Prolog::Services::MarkdownToHtml
  end
end
