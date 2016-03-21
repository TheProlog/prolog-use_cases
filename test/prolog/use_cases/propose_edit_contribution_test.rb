
require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution'

describe 'Prolog::UseCases::ProposeEditContribution' do
  let(:described_class) { Prolog::UseCases::ProposeEditContribution }
  let(:article) do
    Struct.new(:author_name, :body, :title).new author_name, body, title
  end
  let(:article_repo) { Object.new }
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
        self
      end

      def add(entity)
        @added_data << entity
        entity
      end

      def create(**params)
        obj = OpenStruct.new(params)
        @created_data << obj
        obj
      end
    end.new
  end
  let(:init_params) do
    { article: article, authoriser: authoriser,
      contribution_repo: contribution_repo, article_repo: article_repo,
      ui_gateway: ui_gateway }
  end
  let(:is_guest) { false }
  let(:title) { 'Article Title' }
  let(:ui_gateway) { Object.new }
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

    it ':article' do
      @param = :article
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
    expect { described_class.new init_params }.must_be_silent
  end

  describe 'has a #call method that' do
    let(:call_params) do
      { endpoints: endpoints, proposed_content: proposed_content }
    end
    let(:endpoints) { (ep_begin..ep_end) }
    let(:justification) { 'Justification is left, right, or centred.' }
    let(:proposed_content) { 'very last' }
    let(:snippet) { '<em>last</em>' }
    let(:ep_begin) { article.body.index snippet }
    let(:ep_end) { ep_begin + snippet.length - 1 }

    describe 'requires parameters for' do
      after do
        call_params.delete @param
        expected = ArgumentError
        error = expect { obj.call call_params }.must_raise expected
        expect(error.message).must_match @param.to_s
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

    describe 'when the initiating member is' do
      describe 'not the article author' do
        let(:created_obj) { contribution_repo.created_data.first }
        let(:user_name) { 'Wilma Wormwood' }

        before do
          call_params[:justification] = justification
          obj.call call_params
        end

        it 'creates a Proposed Article' do
          expect(created_obj.status).must_equal :proposed
        end

        it 'adds the newly-created Proposed Article to the repository' do
          expect(contribution_repo.added_data.first).must_equal created_obj
        end
      end # describe 'not the article author'
    end # describe 'when the initiating member is'
  end # describe 'has a #call method that'
end # Prolog::UseCases::ProposeEditContribution
