
require 'test_helper'

require 'pandoc-ruby'

describe 'Pandoc basics' do
  describe 'converts empty anchor tag pairs with IDs to span tag pairs' do
    let(:html_content) do
      content = %(<p>This is
        <a id="contribution-27-begin"></a>
        <a id="contribution-9-begin"></a>
        obviously
        <em>sample
          <a id="contribution-27-end"></a>
          and disposable
        </em>
        content.
        <a id="contribution-9-end"></a>
      </p>)
      content.lines.map(&:strip).join
    end
    let(:markdown) do
      PandocRuby.convert(html_content, from: :html, to: :markdown_github)
    end
    let(:converted_html) do
      # Pandoc adds a aterminating "\n"; kill it."
      PandocRuby.convert(markdown, from: :markdown_github, to: :html).rstrip
    end

    it 'does not produce lexically identical content' do
      expect(converted_html).wont_equal html_content
    end

    it 'replaces empty :a tags with :span tags' do
      fiddled = html_content.gsub('<a id', '<span id').gsub('</a>', '</span>')
      expect(fiddled).must_equal converted_html
    end
  end # describe 'converts empty anchor tag pairs with IDs to span tag pairs'
end
