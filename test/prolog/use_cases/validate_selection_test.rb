
require 'test_helper'

require 'prolog/use_cases/validate_selection'

describe 'Prolog::UseCases::ValidateSelection' do
  let(:described_class) { Prolog::UseCases::ValidateSelection }

  describe 'initialisation requires parameters for' do
    let(:params) do
      { article: article, replacement_content: replacement_content,
        endpoints: endpoints, authoriser: authoriser,
        contribution_repo: contribution_repo, ui_gateway: ui_gateway }
    end
    let(:article) { Object.new }
    let(:authoriser) { Object.new }
    let(:contribution_repo) { Object.new }
    let(:endpoints) { Object.new }
    let(:replacement_content) { Object.new }
    let(:ui_gateway) { Object.new }

    it 'article' do
      params.delete :article
      error = expect { described_class.new params }.must_raise KeyError
      expect(error.message).must_equal 'key not found: :article'
    end
  end # describe 'initialisation requires parameters for'
end
