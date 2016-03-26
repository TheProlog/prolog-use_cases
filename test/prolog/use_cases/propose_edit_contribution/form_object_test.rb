
require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution/form_object'

describe 'Prolog::UseCases::ProposeEditContribution::FormObject' do
  let(:described_class) do
    Prolog::UseCases::ProposeEditContribution::FormObject
  end
  let(:article) do
    article_class = Struct.new(:title, :body, :author_name)
    article_class.new title, 'A Body', author_name
  end
  let(:author_name) { 'J Random User' }
  let(:authoriser) { authoriser_class.new is_guest, author_name }
  let(:authoriser_class) { Struct.new(:guest?, :user_name) }
  let(:is_guest) { author_name == 'Guest User' }
  let(:params) { { article: article, authoriser: authoriser } }
  let(:title) { 'A Title' }
  let(:obj) { described_class.new params }

  describe 'initialisation' do
    describe 'requires parameters for' do
      after do
        params.delete @param
        error = expect { described_class.new params }.must_raise @error
        expect(error.message).must_match @message
      end

      it 'authoriser' do
        @error = Module::DelegationError
        @message = 'user_name delegated to authoriser.user_name, but' \
          ' authoriser is nil'
        @param = :authoriser
      end

      it 'article' do
        @error = NoMethodError
        @message = %(undefined method `author_name' for nil:NilClass)
        @param = :article
      end
    end # describe 'requires parameters for'

    describe 'accepts parameter values for' do
      it ':endpoints' do
        params[:endpoints] = (5..7)
        expect(obj.endpoints).must_equal params[:endpoints]
      end

      it ':proposed_content' do
        params[:proposed_content] = 'Proposed Content'
        expect(obj.proposed_content).must_equal params[:proposed_content]
      end

      it 'justification' do
        params[:justification] = 'Justification'
        expect(obj.justification).must_equal params[:justification]
      end
    end # describe 'accepts parameter values for'
  end # describe 'initialisation'

  describe 'when initialisation includes an :authoriser parameter' do
    describe 'that describes a registered member' do
      it 'returns false from the #guest? method' do
        expect(obj).wont_be :guest?
      end

      it 'returns true from the #valid? method' do
        expect(obj).must_be :valid?
      end

      it 'has no authoriser errors' do
        obj.valid?
        expect(obj.errors[:authoriser]).must_be :empty?
      end
    end # describe 'that describes a registered member'

    describe 'that describes the Guest User' do
      let(:author_name) { 'Guest User' }

      it 'returns true from the #guest? method' do
        expect(obj).must_be :guest?
      end

      it 'returns false from the #valid? method' do
        expect(obj).wont_be :valid?
      end

      describe 'encodes into an authoriser error message values for' do
        let(:error_data) do
          JSON.parse obj.errors[:authoriser].last, symbolize_names: true
        end

        before { obj.valid? }

        it 'a :failure message' do
          expect(error_data[:failure]).must_equal 'not logged in'
        end

        it 'an :article_id' do
          expected = YAML.dump author_name: author_name, title: title
          expect(error_data[:article_id]).must_equal expected
        end # describe 'that describes the Guest User'
      end # describe 'encodes into an authoriser error message values for'
    end
  end # describe 'when initialisation includes an :authoriser parameter'
end
