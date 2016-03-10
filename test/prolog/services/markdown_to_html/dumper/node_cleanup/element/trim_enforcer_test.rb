
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

    describe 'when called with' do
      let(:el) { Ox.parse markup }
      let(:actual) { described_class.call el }

      describe 'an Ox::Element having a single child string' do
        let(:markup) { '<p>As simple as it gets.</p>' }

        it 'returns the same instance as was passed in' do
          expect(actual.hash).must_equal el.hash
        end

        # Why bother? The Element *instance* is the same; is the contained
        # string?
        it 'does not affect the contained HTML markup' do
          # Ox.dump always adds a newline at the end; kill it
          rendered = Ox.dump(actual, indent: -1)[0..-2]
          expect(rendered).must_equal markup
        end
      end # describe 'an Ox::Element having a single child string'
    end # describe 'when called with'
  end # describe 'has a .call method that'
end
