
require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution'

describe 'Prolog::UseCases::ProposeEditContribution' do
  let(:described_class) { Prolog::UseCases::ProposeEditContribution }
  let(:article_repo) { Object.new }
  let(:authoriser) { Object.new }
  let(:contribution_repo) { Object.new }
  let(:init_params) do
    { article_repo: article_repo, authoriser: authoriser,
      contribution_repo: contribution_repo }
  end
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

  describe 'has a #call method that' do
    let(:call_params) do
      { article_ident: article_ident, endpoints: endpoints,
        justification: justification, proposed_content: proposed_content }
    end
    let(:article_ident) { Object.new }
    let(:endpoints) { Object.new }
    let(:justification) { Object.new }
    let(:proposed_content) { Object.new }

    describe 'must be called with parameters for' do
      after do
        call_params.delete @param
        error = expect { obj.call call_params }.must_raise ArgumentError
        expect(error.message).must_match @param.to_s
      end

      it ':article_identifer' do
        @param = :article_ident
      end

      it ':endpoints' do
        @param = :endpoints
      end

      it ':justification' do
        @param = :justification
      end

      it ':proposed_content' do
        @param = :proposed_content
      end
    end # describe 'must be called with parameters for'

    describe 'when called with a complete set of valid parameters' do
      it 'queries the Article Repository for the specified Article/Author'

      it 'queries the Authoriser for the current Member name'

      it 'queries the Contribution Repository for the last Contribution ID'

      it 'calls the service to convert replacement content to HTML'

      describe 'uses Selection Service to update Article body based on' do
        it 'the existing body markup'

        it 'the proposed replacement markup (as HTML)'

        it 'the last-contribution ID'
      end # describe 'uses Selection Service to update Article body based on'

      describe 'adds a new entry to the Contribution Repository, including' do
        it 'the identification of the Article'

        it 'the name of the Member proposing the Contribution'

        it 'the endpoints of the existing markup proposed for replacement'

        # Belt, meet suspenders.
        it 'the markup text proposed for replacement'

        it 'the proposed updated body markup'

        it 'the contribution-ID sequence number'

        it 'the supplied justification content (as Markdown)'

        describe 'when proposed by a Member other than the Author' do
          it 'sets the state of the new entry to "proposed"'
        end # describe 'when proposed by a Member other than the Author'

        describe 'when proposed by the Article Author' do
          it 'sets the state of the new entry to "accepted"'
        end # describe 'when proposed by the Article Author'
      end # describe 'adds a new entry to the Contribution Repository'

      describe 'when proposed by a Member other than the Author' do
        describe 'does not update the fields in the Article entity for' do
          it 'body'

          it 'last-updated-at timestamp'
        end # describe 'does not update the fields in the Article entity for'
      end # describe 'when proposed by a Member other than the Author'

      describe 'when proposed by the Article Author' do
        describe 'correctly updates the fields in the Article entity for' do
          it 'body'

          it 'last-updated-at timestamp'
        end # describe 'correctly updates the fields in the Article entity for'
      end # describe 'when proposed by the Article Author'
    end # describe 'when called with a complete set of valid parameters, it'
  end # describe 'has a #call method that'
end # Prolog::UseCases::ProposeEditContribution
