
require 'test_helper'

require 'prolog/use_cases/summarise_content'

describe 'Prolog::UseCases::SummariseContent' do
  let(:described_class) { Prolog::UseCases::SummariseContent }
  let(:all_articles) { YAML.load_file 'test/fixtures/articles.yaml' }
  let(:obj) { described_class.new }
  let(:current_user_name) { 'Guest User' }

  it 'has a #call instance method taking no parameters' do
    method = obj.method(:call)
    expect(method.arity).must_equal 0
  end

  describe 'has a #call method that' do
    let(:auth_listener) do
      Class.new do
        include Wisper::Publisher

        attr_reader :count

        def initialize(user_name)
          @user_name = user_name
          @count = 0
          self
        end

        def current_user
          @count += 1
          broadcast :current_user_is, user_name
          self
        end

        private

        attr_reader :user_name
      end.new current_user_name
    end
    let(:persistence_listener) do
      Class.new do
        include Wisper::Publisher

        attr_reader :user_names

        def initialize(articles)
          @user_names = []
          @articles = articles
        end

        def all_articles_permitted_to(user_name)
          @user_names << user_name
          broadcast :all_articles, articles
        end

        private

        attr_reader :articles
      end.new(all_articles)
    end

    describe 'broadcasts the message' do
      it ':current_user' do
        obj.subscribe auth_listener
        obj.call
        expect(auth_listener.count).must_equal 1
      end

      it ':all_articles_permitted_to message with the current user name' do
        obj.subscribe auth_listener
        obj.subscribe persistence_listener
        obj.call
        expect(persistence_listener.user_names).must_equal [current_user_name]
      end
    end # describe 'broadcasts the message'
  end # describe 'has a #call method that'
end
