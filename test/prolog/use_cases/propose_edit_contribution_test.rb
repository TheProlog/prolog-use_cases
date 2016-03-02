
require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution'

describe 'Prolog::UseCases::ProposeEditContribution' do
  let(:described_class) { Prolog::UseCases::ProposeEditContribution }

  it 'may not be initialised without arguments' do
    expect { described_class.new }.must_raise ArgumentError
  end

  describe 'must be initialised with parameters for' do
    let(:article_repo) { Object.new }
    let(:authoriser) { Object.new }
    let(:contribution_repo) { Object.new }
    let(:params) do
      { article_repo: article_repo, authoriser: authoriser,
        contribution_repo: contribution_repo }
    end

    after do
      params.delete @param
      error = expect { described_class.new params }.must_raise ArgumentError
      expect(error.message).must_match @param.to_s
    end

    it ':article_repo' do
      @param = :article_repo
    end

    it ':authoriser' do
      @param = :authoriser
    end

    it ':contribution_repo' do
      @param = :contribution_repo
    end
  end # describe 'must be initialised with parameters for'
end # Prolog::UseCases::ProposeEditContribution
