
require 'test_helper'

require 'ox'

require 'prolog/services/markdown_to_html/dumper/node_cleanup'

describe 'Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup' do
  let(:described_class) do
    Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
  end

  describe 'has a #call method that' do
    let(:obj) { described_class.new }

    describe 'when called with' do
      let(:node) { Ox.parse @markup }
      let(:rendered) { Ox.dump(node, indent: -1)[0..-2] }

      after do
        obj.cleanup nodes: [node]
        expect(rendered).must_equal expected
      end

      describe 'a single Element, enclosed text string has' do
        let(:expected) { '<p>This is a test.</p>' }

        it 'leading whitespace removed' do
          @markup = "<p>\n  This is a test.</p>"
        end

        it 'trailing whitespace removed' do
          @markup = "<p>This is a test.\n  </p>"
        end

        it 'other whitespace converted to a space character' do
          @markup = "<p>\tThis\ris a\rtest.</p>"
        end

        it 'redundant spaces eliminated' do
          @markup = "<p>This\r\nis  a  test.</p>"
        end
      end # describe 'a single Element, enclosed text string has'

      describe 'an Element containing another Element, text has' do
        let(:expected) { '<b><i>This is a test.</i></b>' }

        it 'leading whitespace removed' do
          @markup = "<b>\n  <i>\n  This is a test.\n</i></b>"
        end

        it 'trailing whitespace removed' do
          @markup = "<b><i>This is a test.\n</i>  </b>\n"
        end

        it 'other whitespace coonverted to a space character' do
          @markup = "<b>\r\n<i>\tThis\ris a\rtest.</i>\r\n</b>"
        end

        it 'redundant spaces eliminated' do
          @markup = '<b><i>This  is   a    test.      </i>  </b>'
        end
      end # describe 'an Element containing another Element, text has'

      describe 'an Element containing an Element and a string, text has' do
        let(:expected) { '<p><em>Leading emphasis</em> goes here.</p>' }

        it 'element leading whitespace removed' do
          @markup = '<p><em>  Leading emphasis</em>  goes here.</p>'
        end

        it 'element trailing mwhitespace removed' do
          @markup = '<p><em>Leading emphasis  </em>  goes here.</p>'
        end

        it 'other whitespace coonverted to a space character' do
          @markup = "<p><em>Leading\r\nemphasis\t</em>  goes here.</p>"
        end

        it 'redundant spaces eliminated' do
          @markup = '<p><em>Leading      emphasis</em> goes here.</p>'
        end
      end # describe 'an Element containing an Element and a string, text has'
    end # describe 'when called with'
  end # describe 'has a #call method that'
end
