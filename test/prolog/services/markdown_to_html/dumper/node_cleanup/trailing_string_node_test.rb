
require 'test_helper'

require 'prolog/services/markdown_to_html/dumper/node_cleanup/' \
  'trailing_string_node'

cls_name = Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
           .const_get(:TrailingStringNode)

describe "#{cls_name}" do
  let(:described_class) { cls_name }

  it 'requires a :string parameter for initialisation' do
    error = expect { described_class.new }.must_raise ArgumentError
    expect(error.message).must_equal 'missing keyword: string'
  end

  describe 'has a #to_s method that' do
    describe 'when initialised with a string which contains' do
      let(:obj) { described_class.new string: string }

      describe 'no excess whitespace' do
        let(:string) { 'This is a valid string.' }

        it 'returns the same string' do
          expect(obj.to_s).must_equal string
        end
      end # describe 'no excess whitespace'

      describe 'trailing whitespace but no leading whitespace' do
        let(:string) { "This is a raw string  \n  " }

        it 'returns the string without trailing whitespace' do
          expect(obj.to_s).must_equal string.rstrip
        end
      end # describe 'leading whitespace but no trailing whitespace'

      describe 'both leading and trailing whitespace, returns the string' do
        let(:string) { "  This is a raw string  \n" }

        it 'without trailing whitespace' do
          expected = string.strip
          expect(obj.to_s[-expected.length..-1]).must_equal expected
        end

        it 'with a single space before the string text' do
          expected = ' ' + string.strip[0]
          expect(obj.to_s).must_match expected
        end
      end # describe 'both leading and trailing whitespace, returns the string'
    end # describe 'when initialised with a string which contains'
  end # describe 'has a #to_s method that'
end
