
require 'test_helper'

require 'prolog/services/markdown_to_html/dumper/simple_element'

describe 'Prolog::Services::MarkdownToHtml::Dumper::SimpleElement' do
  let(:described_class) do
    Prolog::Services::MarkdownToHtml::Dumper::SimpleElement
  end

  it 'requires a :node parameter for initialisation' do
    error = expect { described_class.new }.must_raise ArgumentError
    expect(error.message).must_equal 'missing keyword: node'
  end

  describe 'when initialised with a single Ox::Element node' do
    let(:node) { Ox.parse markup }
    let(:obj) { described_class.new node: node }
    let(:clean_markup) { '<p>This is a simple paragraph.</p>' }

    describe 'containing no excess whitespace, it' do
      let(:markup) { clean_markup }

      it 'has a #to_s method returning the cleaned-up markup for the element' do
        expect(obj.to_s).must_equal clean_markup
      end
    end # describe 'containing no excess whitespace, it'

    describe 'which contains junk whitespace, it' do
      let(:markup) { "\n<p>\nThis is a simple paragraph.   </p>\n" }

      it 'has a #to_s method returning the cleaned-up markup for the element' do
        expect(obj.to_s).must_equal clean_markup
      end
    end # describe 'which contains junk whitespace, it'
  end # describe 'when initialised with a single Ox::Element node'
end
