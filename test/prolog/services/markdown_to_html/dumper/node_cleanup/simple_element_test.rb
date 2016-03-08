
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

  describe 'when initialised with a single Ox::Element node which contains' do
    let(:node) { Ox.parse markup }
    let(:obj) { described_class.new node: node }
    let(:clean_markup) { '<p>This is a simple paragraph.</p>' }

    describe 'no excess whitespace, it' do
      let(:markup) { clean_markup }

      it 'has a #to_s method returning the cleaned-up markup for the element' do
        expect(obj.to_s).must_equal clean_markup
      end
    end # describe 'no excess whitespace, it'

    describe 'junk whitespace, it' do
      let(:markup) { "\n<p>\nThis is a simple paragraph.   </p>\n" }

      it 'has a #to_s method returning the cleaned-up markup for the element' do
        expect(obj.to_s).must_equal clean_markup
      end
    end # describe 'junk whitespace, it'

    describe 'ONLY whitespace, it' do
      let(:markup) { "\n<p>   \n\n</p>\n" }

      it 'has a #to_s method returning a single space as element content' do
        expect(obj.to_s).must_equal '<p> </p>'
      end
    end # describe 'ONLY whitespace, it'

    describe 'a supported (X)HTML void element, it' do
      let(:markup) { "\n  <hr/>\n" }

      it 'has a #to_s method which returns the tag without extra whitespace' do
        expect(obj.to_s).must_equal '<hr/>'
      end
    end # describe 'a supported (X)HTML void element, it'

    describe 'an unsupported (X)HTML void element, it' do
      let(:markup) { '<param name="timezone" value="SGT" />' }

      it 'has a #to_s method that renders the element invalidly' do
        expected = '<param name="timezone" value="SGT"> </param>'
        expect(obj.to_s).must_equal expected
      end
    end # describe 'an unsupported (X)HTML void element, it'
  end # describe 'when ... with a single Ox::Element node which contains'
end
