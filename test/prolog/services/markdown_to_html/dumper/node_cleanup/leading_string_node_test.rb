
require 'test_helper'

require 'prolog/services/markdown_to_html/dumper/node_cleanup/' \
  'leading_string_node'

cls_name = Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
           .const_get(:LeadingStringNode)

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

      describe 'leading whitespace but no trailing whitespace' do
        let(:string) { "\n  This is a raw string" }

        it 'returns the string without leading whitespace' do
          expect(obj.to_s).must_equal string.lstrip
        end
      end # describe 'leading whitespace but no trailing whitespace'

      describe 'both leading and trailing whitespace, returns the string' do
        let(:string) { "  This is a raw string  \n" }

        it 'without leading whitespace' do
          expect(obj.to_s).must_match string.strip
        end

        it 'with a single space after the string text' do
          expected = string.strip[-1] + ' '
          expect(obj.to_s[-2..-1]).must_equal expected
        end
      end # describe 'both leading and trailing whitespace, returns the string'
    end # describe 'when initialised with a string which contains'
  end # describe 'has a #to_s method that'
end
