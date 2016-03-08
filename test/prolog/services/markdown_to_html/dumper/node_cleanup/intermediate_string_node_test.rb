
require 'test_helper'

require 'prolog/services/markdown_to_html/dumper/node_cleanup/' \
  'intermediate_string_node'

cls_name = Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
           .const_get(:IntermediateStringNode)

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

        it 'returns the string with a single leading space' do
          expected = [' ', string.lstrip].join
          expect(obj.to_s).must_match expected
        end
      end # describe 'leading whitespace but no trailing whitespace'

      describe 'both leading and trailing whitespace, returns the string' do
        let(:string) { "  This is a raw string  \n" }

        it 'with a single leading and single trailing whitespace' do
          expected = [' ', ' '].join string.strip
          expect(obj.to_s).must_equal expected
        end
      end # describe 'both leading and trailing whitespace, returns the string'
    end # describe 'when initialised with a string which contains'
  end # describe 'has a #to_s method that'
end
