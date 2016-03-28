
require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution/form_object'

describe 'Prolog::UseCases::ProposeEditContribution::FormObject' do
  let(:described_class) do
    Prolog::UseCases::ProposeEditContribution::FormObject
  end
  let(:article) do
    article_class.new title, 'A Body', author_name
  end
  let(:article_class) { Struct.new(:title, :body, :author_name) }
  let(:author_name) { user_name }
  let(:authoriser) { authoriser_class.new is_guest, user_name }
  let(:authoriser_class) { Struct.new(:guest?, :user_name) }
  let(:guest_user_name) { 'Guest User' }
  let(:is_guest) { author_name == 'Guest User' }
  let(:params) { { article: article, authoriser: authoriser } }
  let(:title) { 'A Title' }
  let(:user_name) { 'J Random User' }
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

  describe 'has a #valid? method that' do
    before { obj.valid? }

    describe 'when no member is logged in/authorised' do
      let(:user_name) { guest_user_name }

      it 'returns false from the method' do
        expect(obj).wont_be :valid?
      end

      it 'reports a single error' do
        expect(obj.errors[:authoriser].count).must_equal 1
      end

      describe 'reports an error' do
        it 'associated with the authoriser' do
          expect(obj.errors.keys.first).must_equal :authoriser
        end

        describe 'whose message text is a JSON string encoding' do
          let(:payload) do
            JSON.parse obj.errors[:authoriser].first, symbolize_names: true
          end

          describe 'a Hash containing' do
            it 'a :failure entry reading "not logged in"' do
              expect(payload[:failure]).must_equal 'not logged in'
            end

            describe 'an :article_id entry encoding' do
              let(:article_id) { YAML.load payload[:article_id] }

              it 'an :author_name string' do
                expect(article_id[:author_name]).must_equal author_name
              end

              it 'a :title string' do
                expect(article_id[:title]).must_equal title
              end
            end # describe 'an :article_id entry encoding'
          end # describe 'a Hash containing'
        end # describe 'whose message text is a JSON string encoding'
      end # describe 'reports an error'
    end # describe 'when no member is logged in/authorised'
  end # describe 'has a #valid? method that'

  describe 'has a #status attribute that, when called while' do
    it 'cannot be set' do
      expect { obj.status = :proposed }.must_raise NoMethodError
    end

    describe 'a member other than the author is logged in' do
      let(:author_name) { 'Somebody Else' }

      it 'has the value :proposed' do
        expect(obj.status).must_equal :proposed
      end
    end # describe 'a member other than the author is logged in'

    describe 'the author is logged in' do
      it 'has the value :accepted' do
        expect(obj.status).must_equal :accepted
      end
    end # describe 'the author is logged in'
  end # describe 'has a #status attribute that, when called while'

  # NOTE: `#wrap_contribution_with` has *NO PROTECTIONS*. It *will* insert the
  #       identified-anchor tag pairs *exactly* where you tell it to. If that
  #       results in broken HTML that Ox or anything else can't deal with, it's
  #       all on *YOU*. Protip: remember that the endpoint you specify should
  #       begin at the index of the first character you want to wrap, and end at
  #       the index of the first character *after* what you want to wrap. YHBW.
  describe 'has a #wrap_contribution_with method that' do
    let(:article) do
      article_class.new 'A Title', body, author_name
    end
    let(:body) { Marshal.load(Marshal.dump original_body) }
    let(:contribution_id) { 271 }
    let(:endpoints) { (3..7) }
    let(:expected) do
      ret = original_body[0...endpoints.begin]
      ret += %(<a id=\"contribution-#{contribution_id}-begin\"></a>)
      ret += original_body[endpoints.begin...endpoints.end]
      ret += %(<a id=\"contribution-#{contribution_id}-end\"></a>)
      ret + original_body[endpoints.end..-1]
    end
    let(:original_body) { '<p>This is <em>simple</em> content.</p>' }
    let(:params) do
      { article: article, authoriser: authoriser, endpoints: endpoints,
        proposed_content: proposed_content }
    end
    let(:proposed_content) { '<em>That</em>' }
    let(:obj) { described_class.new params }

    before { obj.wrap_contribution_with contribution_id }

    describe 'when called while a member is logged in/authorised' do
      it 'wraps the raw markup within the endpoints with anchor pairs' do
        expect(obj.article.body).must_equal expected
      end
    end # describe 'when called while a member is logged in/authorised'

    describe 'when called while no member is logged in/authorised' do
      let(:user_name) { guest_user_name }

      it 'makes no modification to the article body' do
        expect(obj.article.body).must_equal original_body
      end

      it 'reports an authorisation error: that no member is logged in' do
        encoded_message = obj.errors[:authoriser].first
        error_info = JSON.parse encoded_message, symbolize_names: true
        expect(error_info[:failure]).must_equal 'not logged in'
      end
    end # describe 'when called while no member is logged in/authorised'

    # Tested separately as an earlier implementation had varying error messages
    # for each of the three error conditions, even though ActiveModel::Errors
    # by default does not. (Were we using, say, Dry::Validation, however...)
    describe 'when called with proposed input that is' do
      let(:payload) do
        JSON.parse obj.errors[:proposed_content].first, symbolize_names: true
      end
      let(:article_id) { YAML.load payload[:article_id] }
      let(:expected_article_id) do
        { author_name: article.author_name, title: article.title }
      end

      describe 'missing' do
        let(:proposed_content) { nil }

        it 'makes no modification to the article body' do
          expect(obj.article.body).must_equal original_body
        end

        it 'reports that proposed content is missing' do
          expect(payload[:failure]).must_equal 'missing proposed content'
        end

        it 'reports the correct article-ID data' do
          expect(article_id).must_equal expected_article_id
        end
      end # describe 'missing'

      describe 'empty' do
        let(:proposed_content) { '' }

        it 'makes no modification to the article body' do
          expect(obj.article.body).must_equal original_body
        end

        it 'reports that proposed content is empty' do
          expect(payload[:failure]).must_equal 'empty proposed content'
        end

        it 'reports the correct article-ID data' do
          expect(article_id).must_equal expected_article_id
        end
      end # describe 'empty'

      describe 'blank' do
        let(:proposed_content) { '   ' }

        it 'makes no modification to the article body' do
          expect(obj.article.body).must_equal original_body
        end

        it 'reports that proposed content is blank' do
          expect(payload[:failure]).must_equal 'blank proposed content'
        end

        it 'reports the correct article-ID data' do
          expect(article_id).must_equal expected_article_id
        end
      end # describe 'blank'
    end # describe 'when called with proposed input that is'
  end # describe 'has a #wrap_contribution_with method that'
end
