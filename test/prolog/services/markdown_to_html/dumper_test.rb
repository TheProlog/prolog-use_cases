
require 'test_helper'

require 'prolog/services/markdown_to_html/dumper'

describe 'Prolog::Services::MarkdownToHtml::Dumper' do
  let(:described_class) { Prolog::Services::MarkdownToHtml::Dumper }

  it 'requires a :node parameter for initialisation' do
    error = expect { described_class.new }.must_raise ArgumentError
    expect(error.message).must_equal 'missing keyword: node'
  end

  describe 'when initialised with' do
    let(:node) { Ox.parse markup }
    let(:obj) { described_class.new node: node }

    describe 'a single Ox::Element node, it' do
      let(:markup) { '<p>This is a paragraph.</p>' }

      it 'returns the original markup from the #to_s method' do
        expect(obj.to_s).must_equal markup
      end
    end # describe 'a single Ox::Element node, it'

    describe 'an Element containing child elements, it' do
      let(:markup) do
        "<div>\n  <p>First paragraph.</p>\n  <p>Second paragraph.</p>\n</div>"
      end

      it 'returns the original markup without inter-element whitespace' do
        expected = markup.lines.map(&:strip).join
        expect(obj.to_s).must_equal expected
      end
    end # describe 'an Element containing child elements, it'

    describe 'an Element whose child elements contain non-clean text strings' do
      let(:markup) do
        "<div>\n<p>\nThis  is a  test.\n</p>\n" \
        "<ol>\n  <li>First\n<em>\n<strong>\nitem  </strong></em>\n</li>\n  " \
        "<li>Second item</li>\n  <li>  Last item </li>\n  </ol></div>"
      end
      let(:clean_markup) do
        '<div><p>This is a test.</p><ol>' \
        '<li>First <em><strong>item</strong></em></li>' \
        '<li>Second item</li><li>Last item</li></ol></div>'
      end

      it 'returns properly cleaned-up markup' do
        expect(obj.to_s).must_equal clean_markup
      end
    end # describe 'an Element whose child elements ... non-clean text strings'
  end # describe 'when initialised with'
end
