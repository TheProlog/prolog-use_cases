
require 'test_helper'

require 'prolog/use_cases/retrieve_article/form_object'

describe 'Prolog::UseCases::RetrieveArticle::FormObject' do
  let(:described_class) { Prolog::UseCases::RetrieveArticle::FormObject }
  let(:params) do
    { current_user: current_user, author_name: author_name, title: title,
      body: body, image_url: 'image url', repository: repository }
  end
  let(:current_user) { 'current user' }
  let(:author_name) { 'author name' }
  let(:title) { 'title' }
  let(:body) { 'body' }
  let(:image_url) { 'image url' }
  let(:repository) { 'repository' }
  let(:obj) { described_class.new params }

  describe 'accepts initialisation with' do
    it 'all supported attributes' do
      actual = params.select { |sym, value| obj[sym] == value }
      expect(actual).must_equal params
    end

    it 'omitting :author_name, defaulting to the value for :current_user' do
      params.delete :author_name
      expect(obj.author_name).must_equal current_user
    end

    it 'does not support a :keywords attribute' do
      params[:keywords] = %w(foo bar baz)
      expect(obj).wont_respond_to :keywords
    end
  end # describe 'accepts initialisation with'

  it 'does not support modifying values' do
    expect { obj[:title] = 'Another Title' }.must_raise NoMethodError
  end

  describe 'has an #article method that returns' do
    let(:actual) { obj.article }
    let(:dummy_repo) { dummy_repo_class.new find_result }
    let(:dummy_repo_class) do
      Class.new do
        def initialize(canned_result)
          @canned_result = canned_result.freeze
          self
        end

        def find(**_params)
          @canned_result
        end
      end # class
    end
    let(:find_result) { [OpenStruct.new(params)] }

    it ':invalid_repository unless :repository responds to #find' do
      expect(actual).must_equal :invalid_repository
      params[:repository] = dummy_repo
      expect(described_class.new(params).article).wont_equal :invalid_repository
    end

    describe ':non_specific_search_terms if the repository finds' do
      after do
        params[:repository] = dummy_repo_class.new @find_result
        expect(actual).must_equal :non_specific_search_terms
      end

      it 'no matches' do
        @find_result = [].freeze
      end

      it 'multiple matches' do
        item = OpenStruct.new(params).freeze
        @find_result = [item, item]
      end
    end # describe ':non_specific_search_terms if the repository finds'
  end # describe 'has an #article method that returns'
end
