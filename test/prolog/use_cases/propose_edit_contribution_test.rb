
require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution'

describe 'Prolog::UseCases::ProposeEditContribution' do
  let(:described_class) { Prolog::UseCases::ProposeEditContribution }
  let(:article) { Object.new }
  let(:authoriser) do
    Struct.new(:guest?).new is_guest
  end
  let(:contribution_repo) { Object.new }
  let(:init_params) do
    { article: article, authoriser: authoriser,
      contribution_repo: contribution_repo }
  end
  let(:is_guest) { false }
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
  end # describe 'must be initialised with parameters for'

  it 'may be initialised with valid parameters' do
    expect { described_class.new init_params }.must_be_silent
  end
end # Prolog::UseCases::ProposeEditContribution
