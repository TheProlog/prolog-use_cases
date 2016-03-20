
require 'test_helper'

require 'prolog/entities/edit_contribution/proposed'

describe 'Prolog::Entities::EditContribution::Proposed' do
  let(:described_class) { Prolog::Entities::EditContribution::Proposed }
  let(:article_id) do
    Prolog::Entities::ArticleIdent.new author_name: author_name, title: title
  end
  let(:author_name) { 'Joe Palooka' }
  let(:title) { 'A Title' }
  let(:endpoints) { (0..5) }
  let(:justification) { 'This is a justification.' }
  let(:proposed_content) { 'This is proposed content.' }
  let(:proposer_name) { 'Somebody Else' }
  let(:params) do
    { article_id: article_id, proposed_content: proposed_content,
      proposer_name: proposer_name }
  end

  describe 'initialisation' do
    describe 'requires a parameter value for' do
      before do
        @cls = String
      end

      after do
        params.delete @param
        error_class = Virtus::CoercionError
        error = expect { described_class.new params }.must_raise error_class
        expected = "Failed to coerce attribute `#{@param}' from nil into " \
          "#{@cls}"
        expect(error.message).must_equal expected
      end

      it ':article_id' do
        @cls = Prolog::Entities::ArticleIdent
        @param = :article_id
      end

      it ':proposed_content' do
        @param = :proposed_content
      end

      it ':proposer_name' do
        @param = :proposer_name
      end
    end # describe 'requires a parameter value for'

    describe 'has expected default values for attributes' do
      it ':endpoints' do
        expect(described_class.new(params).endpoints).must_equal(-1..-1)
      end

      it ':justification' do
        expect(described_class.new(params).justification).must_equal ''
      end
    end # describe 'has expected default values for attributes'

    describe 'accepts a parameter value for' do
      it ':endpoints' do
        params[:endpoints] = endpoints
        obj = described_class.new params
        expect(obj.endpoints).must_equal endpoints
      end

      it ':justification' do
        params[:justification] = justification
        obj = described_class.new params
        expect(obj.justification).must_equal justification
      end
    end # describe 'accepts a parameter value for'
  end # describe 'initialisation'
end
