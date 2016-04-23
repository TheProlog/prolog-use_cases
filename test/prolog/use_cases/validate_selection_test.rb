
require 'test_helper'

require 'prolog/use_cases/validate_selection'

describe 'Prolog::UseCases::ValidateSelection' do
  let(:described_class) { Prolog::UseCases::ValidateSelection }

  describe 'initialisation requires parameters for' do
    let(:params) do
      { article: article, replacement_content: replacement_content,
        endpoints: endpoints, authoriser: authoriser, ui_gateway: ui_gateway }
    end
    let(:article) { Struct.new(:body).new 'Body Content is Here.' }
    let(:authoriser) { Object.new }
    let(:endpoints) { (7..11) }
    let(:replacement_content) { Object.new }
    let(:ui_gateway) { Object.new }

    [:article, :endpoints].each do |attrib|
      it "#{attrib}" do
        params.delete attrib
        obj = described_class.new params
        expect(obj).wont_be :valid?
      end
    end
  end # describe 'initialisation requires parameters for'
end
