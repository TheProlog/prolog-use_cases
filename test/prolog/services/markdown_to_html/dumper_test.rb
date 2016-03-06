
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
  end # describe 'when initialised with'
end
