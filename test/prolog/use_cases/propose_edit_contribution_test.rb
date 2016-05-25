# frozen_string_literal: true

require 'test_helper'

require 'uuid'

require 'prolog/use_cases/propose_edit_contribution'

describe 'Prolog::UseCases::ProposeEditContribution' do
  let(:described_class) { Prolog::UseCases::ProposeEditContribution }
  let(:article) do
    Struct.new(:author_name, :body, :title).new author_name, body, title
  end
  let(:article_repo) do
    Class.new do
      attr_reader :added_data

      def initialize
        @added_data = []
        self
      end

      def add(entity)
        @added_data << entity
        entity
      end
    end.new
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
  let(:contribution_repo) do
    Class.new do
      attr_reader :added_data, :created_data

      def initialize
        @added_data = []
        @created_data = []
        @contribution_id = 0
        self
      end

      def add(entity)
        @contribution_id += 1
        entity.contribution_id = @contribution_id
        entity.saved_at = DateTime.now
        @added_data << entity
        entity
      end

      def count
        @added_data.count
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
    { authoriser: authoriser, contribution_repo: contribution_repo,
      article_repo: article_repo, ui_gateway: ui_gateway }
  end
  let(:is_guest) { false }
  let(:title) { 'Article Title' }
  let(:ui_gateway) do
    Class.new do
      attr_reader :failures, :successes

      def initialize
        @failures = []
        @successes = []
        self
      end

      def success(*params)
        @successes << params
      end

      def failure(*params)
        @failures << params
      end
    end.new
  end
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

    it ':article_repo' do
      @param = :article_repo
    end

    it ':contribution_repo' do
      @param = :contribution_repo
    end

    it ':ui_gateway' do
      @param = :ui_gateway
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
      end # describe 'when called with valid parameters'
    end # describe 'returns a "result" object that'
  end # describe 'has a #call method that'
end # Prolog::UseCases::ProposeEditContribution
