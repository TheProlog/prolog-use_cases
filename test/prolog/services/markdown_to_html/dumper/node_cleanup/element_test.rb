
require 'test_helper'

require 'ox'

require 'prolog/services/markdown_to_html/dumper/node_cleanup/element'

cls_name = Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup::Element

describe "#{cls_name}" do
  let(:described_class) { cls_name }
  # From Wikipedia English article on John Stuart Mill's work, *On Liberty*,
  # licensed under The Creative Commons Attribution-ShareAlike license. Chosen
  # as it comprises a single paragraph with multiple, though simple, child
  # elements and can be validly broken into multiple physical lines which Ox
  # (and our code) should have no trouble dealing with.
  let(:js_mill_markup) do
    <<~ENDIT
    <p><i><b>On Liberty</b></i> is a philosophical work by <a
    href="/wiki/British_philosophy" title="British philosophy">English
    philosopher</a> <a href="/wiki/John_Stuart_Mill"
    title="John Stuart Mill">John Stuart Mill</a>, originally intended as a
    short essay. The work, published in 1859, applies Mill's ethical system of
    <a href="/wiki/Utilitarianism" title="Utilitarianism">utilitarianism
    </a> to society and the state.<sup id="cite_ref-1" class="reference"><a
    href="#cite_note-1"><span>[</span>1<span>]</span></a></sup><sup
    id="cite_ref-2" class="reference"><a
    href="#cite_note-2"><span>[</span>2<span>]</span></a></sup> Mill attempts to
    establish standards for the relationship between <a href="/wiki/Authority"
    title="Authority">authority</a> and <a href="/wiki/Liberty"
    title="Liberty">liberty</a>. He emphasizes the importance of <a
    href="/wiki/Individual" title="Individual">individuality</a> which he
    conceived as a prerequisite to the higher pleasures—the
    <a href="/wiki/Summum_bonum" title="Summum bonum">summum bonum</a> of
    Utilitarianism. Furthermore, Mill criticised the errors of past attempts to
    defend individuality where, for example, democratic ideals resulted in the
    <a href="/wiki/Tyranny_of_the_majority"
    title="Tyranny of the majority">"tyranny of the majority"</a>. Among the
    standards established in this work are Mill's three basic liberties of
    individuals, his three legitimate objections to government intervention, and
    his two maxims regarding the relationship of the individual to society
    "which together form the entire doctrine of [Mill's] Essay."</p>
    ENDIT
  end
  let(:js_mill) { Ox.parse js_mill_markup }

  # ########################################################################## #
  # #####                        INITIALISATION                          ##### #
  # ############################################################################

  it 'requires initialisation with an :element parameter' do
    error = expect { described_class.new }.must_raise ArgumentError
    expect(error.message).must_equal 'missing keyword: element'
  end

  # ########################################################################## #
  # #####           SINGLE-SPACE ENFORCEMENT WITHIN STRINGS              ##### #
  # ########################################################################## #

  describe 'replaces all in-string whitespace sequences with a single space' do
    let(:obj) { described_class.new element: js_mill }
    let(:actual) { obj.to_node }
    let(:unwanted_whitespace) { /[\t\r\n\f\v]/ }
    # `Ox.dump` *always* adds a trailing newline. Kill it.
    let(:dump) { Ox.dump(actual, indent: -1)[0..-2] }

    it 'replacing non-space whitespace characters' do
      expect(dump).wont_match unwanted_whitespace
    end

    it 'contains no consecutive space characters' do
      expect(dump).wont_match(/\s{2,}/)
    end
  end # describe 'replaces all in-string whitespace ... with a single space'
end
