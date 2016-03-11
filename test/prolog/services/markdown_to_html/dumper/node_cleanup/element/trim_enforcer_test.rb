
require 'test_helper'

require 'prolog/services/markdown_to_html/dumper/node_cleanup/element/' \
  'trim_enforcer'

the_class = Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup::Element
            .const_get(:TrimEnforcer)

describe "#{the_class}" do
  let(:described_class) { the_class }

  describe 'has a .call method that' do
    it 'takes one parameter' do
      expect(described_class.method(:call).arity).must_equal 1
    end

    describe 'when called with an Ox::Element containing' do
      let(:el) { Ox.parse markup }
      let(:actual) { described_class.call el }
      # Ox.dump always adds a newline at the end; kill it.
      let(:rendered) { Ox.dump(actual, indent: -1)[0..-2] }

      describe 'a single child string' do
        let(:markup) { '<p>As simple as it gets.</p>' }

        it 'returns the same instance as was passed in' do
          expect(actual.hash).must_equal el.hash
        end

        it 'does not affect the contained HTML markup' do
          expect(rendered).must_equal markup
        end
      end # describe 'a single child string'

      describe 'a string, an Element, and a string' do
        let(:markup) { "\n<p>This is  <em>emphasised</em> content.\n  </p>" }
        let(:clean_markup) { '<p>This is <em>emphasised</em> content.</p>' }

        it 'returns the same instance as was passed in' do
          expect(actual.hash).must_equal el.hash
        end

        it 'returns an Element that renders to correctly-cleaned-up content' do
          expect(rendered).must_equal clean_markup
        end
      end # describe 'a string, an Element, and a string'

      describe 'a string and an Element' do
        let(:markup) { "<p>This is a\n  <em>test.</em>\n</p>" }
        let(:clean_markup) { '<p>This is a <em>test.</em></p>' }

        it 'returns the same instance as was passed in' do
          expect(actual.hash).must_equal el.hash
        end

        it 'returns an Element that renders to correctly-cleaned-up content' do
          expect(rendered).must_equal clean_markup
        end
      end # describe 'a string and an Element'

      describe 'an Element containing a set of nested Elements and strings' do
        let(:markup) do
          <<-ENDIT
          <div>
          <p>This is the first paragraph. Nothing special here.</p>\n
            <ul><li>
              This is the <em>first</em>\n item in a list.
              </li><li>This is the second item in a list.</li>
              <li>This is the
                <em>third and
                  <strong>last</strong>

                  </em>
              item in a list</li>
              </ul>
          </div>
          ENDIT
        end
        let(:clean_markup) do
          '<div><p>This is the first paragraph. Nothing special here.</p>' \
          '<ul><li>This is the <em>first</em> item in a list.</li>' \
          '<li>This is the second item in a list.</li>' \
          '<li>This is the <em>third and <strong>last</strong></em> item in a' \
          ' list</li></ul></div>'
        end

        it 'returns the same instance as was passed in' do
          expect(actual.hash).must_equal el.hash
        end

        it 'returns an Element that renders to correctly-cleaned-up content' do
          expect(rendered).must_equal clean_markup
        end
      end # describe 'an Element containing ... nested Elements and strings'
    end # describe 'when called with an Ox::Element containing'
  end # describe 'has a .call method that'
end
