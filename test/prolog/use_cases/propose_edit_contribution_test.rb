# frozen_string_literal: true

require 'test_helper'

require 'uuid'

require 'prolog/use_cases/propose_edit_contribution'

describe 'Prolog::UseCases::ProposeEditContribution' do
  let(:described_class) { Prolog::UseCases::ProposeEditContribution }
  let(:article) do
    Struct.new(:author_name, :body, :title).new author_name, body, title
  end
  let(:authoriser) do
    Struct.new(:guest?, :user_name).new is_guest, user_name
  end
  let(:author_name) { 'Clive Screwtape' }
  let(:body) do
    '<p>This is the first paragraph.</p>' \
      '<ul><li>This is the first list item.</li>' \
      '<li>This is the <em>last</em> list item.</li>' \
      '</ul><p>This is the closing paragraph.</p>'
  end
  # FIXME: No spec tests for created data. Should it?
  let(:contribution_repo) do
    Class.new do
      attr_reader :created_data

      def initialize
        @created_data = []
        self
      end

      def create(**params)
        obj = OpenStruct.new(params)
        @created_data << obj
        obj
      end
    end.new
  end
  let(:guest_name) { 'Guest User' }
  let(:init_params) do
    { authoriser: authoriser, contribution_repo: contribution_repo }
  end
  let(:is_guest) { false }
  let(:title) { 'Article Title' }
  let(:user_name) { author_name }
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

    it ':authoriser' do
      @param = :authoriser
    end

    it ':contribution_repo' do
      @param = :contribution_repo
    end
  end # describe 'must be initialised with parameters for'

  it 'may be initialised with valid parameters' do
    expect(described_class.new init_params).must_be_instance_of described_class
  end

  describe 'has a #call method that' do
    let(:call_params) do
      { endpoints: endpoints, proposed_content: proposed_content,
        article: article }
    end
    let(:endpoints) { (ep_begin..ep_end) }
    let(:justification) { 'Justification is left, right, or centred.' }
    let(:proposed_content) { 'very last' }
    let(:snippet) { '<em>last</em>' }
    let(:ep_begin) { article.body.index snippet }
    let(:ep_end) { ep_begin + snippet.length }

    describe 'requires parameters for' do
      after do
        call_params.delete @param
        expected = ArgumentError
        error = expect { obj.call call_params }.must_raise expected
        expect(error.message).must_match @param.to_s
      end

      it ':article' do
        @param = :article
      end

      it ':endpoints' do
        @param = :endpoints
      end

      it 'proposed_content' do
        @param = :proposed_content
      end
    end # describe 'requires parameters for'

    it 'accepts a :justification parameter string' do
      call_params[:justification] = justification
      expect { obj.call call_params }.must_be_silent
    end

    describe 'returns a "result" object that' do
      let(:result) { obj.call call_params }

      describe 'when called with valid parameters' do
        it 'reports no errors' do
          expect(result.errors).must_be :empty?
        end

        it 'reports success' do
          expect(result.success).must_equal true
        end

        it 'reports being successful via a query method' do
          expect(result).must_be :success?
        end

        it 'reports no failure' do
          expect(result.failure).must_equal false
        end

        it 'reports not having failed via a query method' do
          expect(result).wont_be :failure?
        end

        describe 'includes an :article value object whose' do
          it 'title matches that of the article passed in to #call' do
            expect(result.article.title).must_equal article.title
          end

          it 'author name matches that of the article passed in to #call' do
            expect(result.article.author_name).must_equal article.author_name
          end

          describe 'body contains marker tag pairs for' do
            let(:article_body) { result.article.body }

            let(:begin_pattern) do
              /id="contribution-(\h{8}\-\h{4}\-\h{4}\-\h{4}\-\h{12})-begin"/
            end
            let(:end_pattern) do
              /id="contribution-(\h{8}\-\h{4}\-\h{4}\-\h{4}\-\h{12})-end"/
            end

            it 'the beginning endpoint of a Proposed Contribution' do
              expect(article_body.match begin_pattern).wont_be :nil?
            end

            it 'the ending endpoint of a Proposed Contribution' do
              expect(article_body.match end_pattern).wont_be :nil?
            end
          end # describe 'body contains marker tag pairs for'
        end # describe 'includes an :article value object whose'

        describe 'includes a :contribution value object that' do
          let(:result_contribution) { result.contribution }

          it 'has a :proposed status' do
            expect(result_contribution.status).must_equal :proposed
          end

          it 'has the correct values in its :article_id attribute' do
            expected = { author_name: author_name, title: title }
            expect(result_contribution.article_id.to_h).must_equal expected
          end

          it 'has the correct :article attribute' do
            expected = result.article.to_h
            expect(result_contribution.article.to_h).must_equal expected
          end

          describe 'has the correct attribute values from the proposal for' do
            it 'endpoints' do
              expect(result_contribution.endpoints).must_equal endpoints
            end

            it 'proposed content' do
              actual = result_contribution.proposed_content
              expect(actual).must_equal proposed_content
            end

            it 'proposer name' do
              expect(result_contribution.proposed_by).must_equal user_name
            end

            it 'proposed at' do
              actual = result_contribution.proposed_at.to_time
              current = DateTime.now.to_time
              expect(current - actual).must_be :<, 30.0 # seconds
            end

            it 'justification' do
              call_params[:justification] = justification
              expect(result_contribution.justification).must_equal justification
            end

            it 'contribution ID as a UUID' do
              actual = result_contribution.contribution_id
              expect(UUID.validate actual).wont_be :nil?
            end
          end # describe 'has the correct attribute values...for'

          it 'has no :saved_at attribute' do
            expect(result_contribution.to_h.key? :saved_at).must_equal false
          end
        end # describe 'includes a :contribution value object that'

        it 'creates exactly one Contribution entity via the repository' do
          _result = obj.call call_params
          expect(contribution_repo.created_data.count).must_equal 1
        end
      end # describe 'when called with valid parameters'

      describe 'when called with parameters that are invalid because' do
        describe 'the Authoriser says the Author is not the current user' do
          let(:user_name) { 'Somebody Else' } # Could be guest user...

          it 'reports errors' do
            expect(result.errors).wont_be :empty?
          end
        end # describe 'the Authoriser says the Author is not the current user'
      end # describe 'when called with parameters that are invalid because'
    end # describe 'returns a "result" object that'
  end # describe 'has a #call method that'
end # Prolog::UseCases::ProposeEditContribution
