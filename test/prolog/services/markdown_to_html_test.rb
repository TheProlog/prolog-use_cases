
require 'test_helper'

require 'prolog/services/markdown_to_html'

describe 'Prolog::Services::MarkdownToHtml' do
  let(:described_class) { Prolog::Services::MarkdownToHtml }

  it 'has no initializer method, instead using that of BasicObject' do
    method = described_class.new.method :initialize
    expect(method.owner).must_equal BasicObject
  end

  describe 'has a .call method that' do
    it 'requires a :content parameter' do
      error = expect { described_class.call }.must_raise ArgumentError
      expect(error.message).must_equal 'missing keyword: content'
    end

    describe 'returns' do
      let(:actual) { described_class.call content: @content }

      after { expect(actual).must_equal @expected }

      it 'an empty string when :content is an empty string' do
        @content = @expected = ''
      end

      it 'an HTML paragraph wrapping a simple text :content string' do
        @content = 'This is a test.'
        @expected = %w(<p> </p>).join @content
      end

      it 'a sequence of paragraphs wrapping double-newline-separated content' do
        @content = "This is a test.\n\nThis is another test."
        @expected = '<p>This is a test.</p><p>This is another test.</p>'
      end

      it 'a para with content separated by a <br/> tag at an input newline' do
        @content = "This is a test.\nThis is another test."
        @expected = '<p>This is a test.<br/>This is another test.</p>'
      end

      it 'correct markup for more complex input' do
        @content = <<~ENDIT
                   # First Header
                   ## Second Header
                   ### Third Header

                   This is an *initial* paragraph under the ~~third~~ header.

                   * First Item
                   * A *Second* Item
                   * THe *__Last__* Item

                   In closing, we thank the Academy of Lorem Ipsum.
                   ENDIT
        @expected = '<h1>First Header</h1><h2>Second Header</h2>' \
                    '<h3>Third Header</h3><p>This is an <em>initial</em> ' \
                    'paragraph under the <del>third</del> header.</p>' \
                    '<ul><li>First Item</li><li>A <em>Second</em> Item</li>' \
                    '<li>THe <em><strong>Last</strong></em> Item</li></ul>' \
                    '<p>In closing, we thank the Academy of Lorem Ipsum.</p>'
      end
    end # describe 'returns'
  end # describe 'has a .call method that'
end
