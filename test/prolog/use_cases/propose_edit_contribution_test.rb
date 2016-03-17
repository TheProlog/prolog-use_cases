
require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution'

describe 'Prolog::UseCases::ProposeEditContribution' do
  let(:described_class) { Prolog::UseCases::ProposeEditContribution }
  let(:article) do
    Prolog::Core::Article.new author_name: author_name
  end
  let(:authoriser) do
    Struct.new(:guest?, :user_name).new is_guest, user_name
  end
  let(:author_name) { user_name }
  let(:contribution_repo) { Object.new }
  let(:init_params) do
    { article: article, authoriser: authoriser,
      contribution_repo: contribution_repo, ui_gateway: ui_gateway }
  end
  let(:is_guest) { false }
  let(:ui_gateway) { Object.new }
  let(:user_name) { 'Clive Screwtape' }
  let(:obj) { described_class.new init_params }

  it 'may not be initialised without arguments' do
    expect { described_class.new }.must_raise ArgumentError
  end

  describe 'must be initialised with parameters for' do
    after do
      init_params.delete @param
      expected = ArgumentError
      error = expect { described_class.new init_params }.must_raise expected
      expect(error.message).must_match @param.to_s
    end

    it ':article' do
      @param = :article
    end

    it ':authoriser' do
      @param = :authoriser
    end

    it ':contribution_repo' do
      @param = :contribution_repo
    end

    it ':ui_gateway' do
      @param = :ui_gateway
    end
  end # describe 'must be initialised with parameters for'

  it 'may be initialised with valid parameters' do
    expect { described_class.new init_params }.must_be_silent
  end
end # Prolog::UseCases::ProposeEditContribution
