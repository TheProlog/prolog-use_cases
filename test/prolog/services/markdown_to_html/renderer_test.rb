
require 'test_helper'

require 'prolog/services/markdown_to_html/renderer'

describe 'Prolog::Services::MarkdownToHtml::Renderer' do
  let(:described_class) { Prolog::Services::MarkdownToHtml::Renderer }

  it 'is a class' do
    expect(described_class).must_be_instance_of Class
  end

  it 'requires a :content named parameter for initialisation' do
    error = expect { described_class.new }.must_raise ArgumentError
    expect(error.message).must_equal 'missing keyword: content'
  end

  it 'has a #to_s method' do
    expect(described_class.new content: 'content').must_respond_to :to_s
  end

  describe 'when initialised with content that is' do
    let(:obj) { described_class.new content: content }
    let(:actual) { obj.to_s }

    describe 'an empty string' do
      let(:content) { '' }
      let(:expected) { content }

      it 'returns an empty string from #to_s' do
        expect(actual).must_equal expected
      end
    end # describe 'an empty string'

    describe 'a simple string' do
      let(:content) { 'content goes here, as much as you want' }
      let(:expected) { ['<p>', '</p>'].join content }

      it 'returns the simple string wrapped in a <p> element tag pair' do
        expect(actual).must_equal expected
      end
    end # describe 'a simple string with no whitespace'

    describe 'a single line containing Markdown inline formatting' do
      let(:content) { 'This is *styled* content. This is **strong** content.' }
      let(:expected) do
        '<p>This is <em>styled</em> content. This is <strong>strong</strong> ' \
          'content.</p>'
      end

      it 'returns the simple string wrapped in a <p> element' do
        expect(actual).must_equal expected
      end
    end # describe 'a single line containing Markdown inline formatting'

    describe 'Markdown content that includes' do
      describe 'multiple paragraphs' do
        let(:content) do
          "This is the first paragraph.\n\nThis is the second paragraph."
        end
        let(:expected) do
          '<p>This is the first paragraph.</p>' \
            '<p>This is the second paragraph.</p>'
        end

        it 'returns each paragraph wrapped in a <p> element tag pair' do
          expect(actual).must_equal expected
        end
      end # describe 'multiple paragraphs'

      describe 'complex, multiple-top-level-element content' do
        let(:content) do
          <<~ENDIT
          1. First Item.
          2. Second Item.
            * First Nested Item
            * Second Nested Item
          3. Third Item.
          4. Fourth Item.
            1. First nested item
            2. Second nested item.
          5. Final item.

          This is a paragraph.

          This is *emphasised content.* This is not.

          Test complete.

          ENDIT
        end
        let(:expected) do
          '<ol><li>First Item.</li><li>Second Item.' \
            '<ul><li>First Nested Item</li><li>Second Nested Item</li></ul>' \
            '</li><li>Third Item.</li><li>Fourth Item.' \
            '<ol><li>First nested item</li><li>Second nested item.</li></ol>' \
            '</li><li>Final item.</li></ol>' \
            '<p>This is a paragraph.</p>' \
            '<p>This is <em>emphasised content.</em> This is not.</p>' \
            '<p>Test complete.</p>'
        end

        it 'renders each element correctly despite having no common parent' do
          expect(actual).must_equal expected
        end
      end # describe 'complex, multiple-top-level-element content'
    end # describe 'Markdown content that includes'
  end # describe 'when initialised with content that is'
end
