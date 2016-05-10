# frozen_string_literal: true

require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution'

def verify_error(message)
  it 'does not create a new Contribution' do
    expect(contribution_repo.created_data).must_be :empty?
  end

  it 'does not change the article body' do
    expect(article.body).must_equal body
  end

  it 'does not set the :saved_at timestamp on the Article' do
    is_clean = !article.respond_to?(:saved_at) || article.saved_at.nil?
    expect(is_clean).must_equal true
  end

  it 'does not persist the Article to the Article Repository' do
    expect(article_repo.added_data).must_be :empty?
  end

  it "has the reason as '#{message}'" do
    expect(failure_data[:failure]).must_equal message
  end

  describe 'has a YAML-encoded Article ID object with' do
    let(:failed_article_id) { YAML.load failure_data[:article_id] }

    it 'has the correct article title' do
      expect(failed_article_id[:title]).must_equal article.title
    end

    it 'has the correct author name' do
      expect(failed_article_id[:author_name]).must_equal author_name
    end
  end # describe 'has a YAML-encoded Article ID object with'
end

def verify_invalid_content_handling(reason, content, message)
  describe reason.to_s do
    let(:failure_message) { ui_gateway.failures.last.first }
    let(:failure_data) do
      JSON.parse failure_message, symbolize_names: true
    end
    let(:proposed_content) { content }

    before { obj.call call_params }

    verify_error message
  end # describe reason.to_s
end

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
    expect { described_class.new init_params }.must_be_silent
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

    describe 'whether or not the initiating user is the article author' do
      let(:created_obj) { contribution_repo.created_data.first }
      let(:user_name) { 'Wilma Wormwood' }
      let(:last_added) { contribution_repo.added_data.last }

      before do
        call_params[:justification] = justification
        obj.call call_params
      end

      it 'creates a Proposed Contribution' do
        expect(created_obj.status).must_equal :proposed
      end

      it 'adds the newly-created Proposed Contribution to the repository' do
        expect(last_added).must_equal created_obj
      end

      it 'sets the :saved_at timestamp on the persisted Contribution' do
        expect(last_added.saved_at).wont_be :nil?
      end

      describe 'updatexs the Article body with contribution markers for' do
        after do
          body = last_added.article.body
          marker = format '<a id="contribution-1-%s"></a>', @which_end
          expect(body.index(marker)).must_equal @marker_index
        end

        it 'the begin-contribution marker' do
          @which_end = :begin
          @marker_index = endpoints.begin
        end

        it 'the end-contribution marker' do
          @which_end = :end
          begin_marker = '<a id="contribution-1-begin"></a>'
          @marker_index = endpoints.end + begin_marker.length
        end
      end # describe 'updatexs the Article body with contribution markers for'

      describe 'affects the return value of the #contribution attr_reader' do
        let(:last_added_data) { contribution_repo.added_data.last }

        it 'is the as-added Contribution object after calling #call' do
          expect(obj.contribution).must_equal last_added_data
        end
      end # describe 'affects the return value of the #contribution ...'

      describe 'encodes a UI Gateway #success message as JSON with' do
        let(:success_message) { ui_gateway.successes.last.first }
        let(:data) { JSON.parse success_message, symbolize_names: true }

        it 'the correct member name' do
          expect(data[:member]).must_equal user_name
        end

        it 'the correct :contributino_count value' do
          expect(data[:contribution_count]).must_equal 1
        end

        it 'the correct YAML-encoded :article_id data' do
          article_data = YAML.load data[:article_id]
          expected = { author_name: author_name, title: title }
          expect(article_data).must_equal expected
        end
      end # describe 'encodes a UI Gateway #success message as JSON with'

      it 'persists an (updated) entity to the Article Repository' do
        expect(article_repo.added_data.count).must_equal 1
      end
    end # describe 'whether or not the initiating user is the article author'

    describe 'reports failures and performs no updates when' do
      describe 'no user is logged in, or a session expired; it' do
        let(:user_name) { guest_name }
        let(:is_guest) { true }
        let(:failure_message) { ui_gateway.failures.last.first }
        let(:failure_data) do
          JSON.parse failure_message, symbolize_names: true
        end

        before { obj.call call_params }

        verify_error 'not logged in'
      end # describe 'no user is logged in, or a session expired; it'

      describe 'the Proposed Content is' do
        [
          [:empty, '', 'empty proposed content'],
          # [:blank, '     ', 'blank proposed content'],
          # [:missing, nil, 'missing proposed content']
        ].each do |reason, content, message|
          verify_invalid_content_handling reason, content, message
        end
      end # describe 'the Proposed Content is'
    end # describe 'reports failures and performs no updates when'
  end # describe 'has a #call method that'
end # Prolog::UseCases::ProposeEditContribution
