
require 'test_helper'

require 'prolog/services/markdown_to_html/renderer/html_pipeline_converter'

describe 'Prolog::Services::MarkdownToHtml::Renderer::HtmlPipelineConverter' do
  # When running `bundle exec rake`, the `Renderer` class is loaded, which
  # declares this class as a `private_constant`. This is Ruby; there's *always*
  # a workaround. :grinning:
  let(:described_class) do
    Prolog::Services::MarkdownToHtml::Renderer.const_get :HtmlPipelineConverter
  end

  describe 'has a .render method that' do
    let(:the_method) { described_class.method :render }

    it 'converts basic Markdown to HTML' do
      fragment = "This is basic content.\n\nThis is more content."
      expected = '<p>This is basic content.</p><p>This is more content.</p>'
      expect(the_method.call fragment).must_equal expected
    end

    describe 'converts content, properly rendering elements including' do
      before { @expected = nil }

      after do
        expect(the_method.call @fragment).must_equal @expected if @expected
      end

      # Remember, valid HTML *is* valid Markdown.
      # Remember also that we're using the `HTML::Pipeline::ImageMaxWidthFilter`
      # which wraps all <img/> tags in an `<a style="max-width: 100%">` element.
      it '<img/> with attributes' do
        fragment = '<img src="http://example.com/image1.png">'
        expected = %r{<img src="http://example.com/image1.png".*?/></a>}
        expect(the_method.call fragment).must_match expected
      end

      describe '<br/>' do
        it 'without attributes' do
          @fragment = "This is a test.\nThis ends the paragraph."
          @expected = '<p>This is a test.<br/>This ends the paragraph.</p>'
        end

        it 'with attributes' do
          @fragment = 'Testing.<br id="br-1">More testing.'
          @expected = '<p>Testing.<br id="br-1"/>More testing.</p>'
        end
      end # describe '<br/>'

      describe '<hr/>' do
        it 'without attributes' do
          @fragment = "Testing.\n\n----\n\nTest complete."
          @expected = '<p>Testing.</p><hr/><p>Test complete.</p>'
        end

        it 'with attributes' do
          @fragment = '<p>Foo.</p><hr id="hr-1"><p>Bar.</p>'
          @expected = '<p>Foo.</p><hr id="hr-1"/><p>Bar.</p>'
        end
      end # describe '<hr/>'
    end # describe 'converts content, properly rendering elements including'
  end # describe 'has a .render method that'
end
