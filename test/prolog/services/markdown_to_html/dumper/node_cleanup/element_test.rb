
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

  it 'has no initializer method, instead using that of BasicObject' do
    method = described_class.new.method :initialize
    expect(method.owner).must_equal BasicObject
  end

  # ########################################################################## #
  # #####           SINGLE-SPACE ENFORCEMENT WITHIN STRINGS              ##### #
  # ########################################################################## #

  describe 'replaces all in-string whitespace sequences with a single space' do
    let(:actual) { described_class.to_node element: js_mill }
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

  describe 'inspects' do
    let(:actual) { described_class.to_node element: parsed }
    let(:parsed) { Ox.parse markup }
    # Ignore Ox's appending a newline to anything dumped.
    let(:rendered) { Ox.dump(actual, indent: -1)[0..-2] }

    # ######################################################################## #
    # #####     ELEMENT INITIAL STRING NODE HAS NO LEADING WHITESPACE    ##### #
    # ######################################################################## #

    describe '"initial" child strings' do
      let(:markup) { "<p>\n\nThis is <em>another</em> test.</p>" }

      it 'removing all leading whitespace' do
        expect(parsed.nodes.first).wont_equal 'This is '
        expect(actual.nodes.first).must_equal 'This is '
      end
    end # describe '"initial" child strings'

    # ######################################################################## #
    # #####    ELEMENT TERMINAL STRING NODE HAS NO TRAILING WHITESPACE   ##### #
    # ######################################################################## #

    describe '"terminal" child strings' do
      let(:markup) { "<p>This is <em>another</em> test.\n  </p>" }

      it 'removing all trailing whitespace' do
        expect(parsed.nodes.last).wont_equal ' test.'
        expect(actual.nodes.last).must_equal ' test.'
      end
    end # describe '"terminal" child strings'

    # ######################################################################## #
    # #####      WHITESPACE BETWEEN BLOCK-LEVEL ELEMENTS REMOVED         ##### #
    # ######################################################################## #

    # Remember, kids: The best code is the code you don't have to write.
    describe 'rendering of contained block elements' do
      let(:markup) { "<div><p>Hello.</p> \n<p>Goodbye.</p>\n</div>" }
      let(:clean_markup) { '<div><p>Hello.</p><p>Goodbye.</p></div>' }

      it 'removing all whitespace between contained block-level elements' do
        expect(rendered).must_equal clean_markup
      end
    end # describe 'rendering of contained block elements'
  end # describe 'inspects'
end
