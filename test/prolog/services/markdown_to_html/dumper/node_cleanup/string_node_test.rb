
require 'test_helper'

require 'prolog/services/markdown_to_html/dumper/node_cleanup/string_node'

cls_name = Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup::StringNode

describe "#{cls_name}" do
  let(:described_class) { cls_name }

  # ########################################################################## #
  # #####                        INITIALISATION                          ##### #
  # ############################################################################

  it 'requires initialisation with named parameters' do
    error = expect { described_class.new }.must_raise ArgumentError
    expect(error.message).must_match 'missing keywords:'
  end

  describe 'requires initialisation with parameter values for' do
    let(:error_message) do
      ret = ''
      begin
        described_class.new params
      rescue ArgumentError => error
        ret = error.message
      end
      ret
    end
    let(:params) { { string: 'a string', position: :intermediate } }

    after do
      param = name.split('_').last[1..-1]
      expect(error_message).must_match(/#{param}$/)
    end

    it ':string' do
      params.delete :string
    end

    it ':position' do
      params.delete :position
    end
  end # describe 'requires initialisation with parameter values for'

  # ########################################################################## #
  # #####                     INITIAL STRING NODE                        ##### #
  # ########################################################################## #

  describe 'when instantiated for an initial string node in an Element' do
    describe 'has a #to_s method that' do
      describe 'when initialised with a string which contains' do
        let(:obj) do
          described_class.new string: string, position: :initial
        end

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
        end # describe 'both leading and trailing ..., returns the string'

        describe 'redundant whitespace, returns the string' do
          let(:string) { 'This  is    a  raw string.' }

          it 'without redundant whitespace' do
            expect(obj.to_s).must_equal 'This is a raw string.'
          end
        end # describe 'redundant whitespace, returns the string'
      end # describe 'when initialised with a string which contains'
    end # describe 'has a #to_s method that'
  end # describe 'when instantiated for an initial string node in an Element'

  # ########################################################################## #
  # #####                     TERMINAL STRING NODE                       ##### #
  # ########################################################################## #

  describe 'when instantiated for a terminal string node in an Element' do
    describe 'has a #to_s method that' do
      describe 'when initialised with a string which contains' do
        let(:obj) do
          described_class.new string: string, position: :terminal
        end

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
        end # describe 'trailing whitespace but no leading whitespace'

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
        end # describe 'both leading and trailing ..., returns the string'
      end # describe 'when initialised with a string which contains'
    end # describe 'has a #to_s method that'
  end # describe 'when instantiated for a terminal string node in an Element'

  # ########################################################################## #
  # #####                  INTERMEDIATE STRING NODE                      ##### #
  # ########################################################################## #

  describe 'when instantiated for an intermediate string node in an Element' do
    describe 'has a #to_s method that' do
      describe 'when initialised with a string which contains' do
        let(:obj) do
          described_class.new string: string, position: :intermediate
        end

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
        end # describe 'both leading and trailing ..., returns the string'
      end # describe 'when initialised with a string which contains'
    end # describe 'has a #to_s method that'
  end # describe 'when instantiated ... intermediate string node in an Element'
end
