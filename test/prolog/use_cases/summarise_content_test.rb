
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

        attr_reader :called

        def initialize(articles)
          @articles = articles
        end

        def query_all_articles
          @called = @called.to_i + 1
          broadcast :all_articles, articles
        end

        private

        attr_reader :articles
      end.new(all_articles)
    end
    let(:current_user_listener) do
      Class.new do
        attr_reader :current_user_name

        def current_user_is(user_name)
          @current_user_name = user_name
          self
        end
      end
    end

    describe 'no longer broadcasts the message' do
      it ':current_user' do
        obj.subscribe auth_listener
        obj.call
        expect(auth_listener.count).must_be :zero?
      end
    end # describe 'no longer broadcasts the message'

    describe 'broadcasts the message' do
      it ':all_articles' do
        obj.subscribe persistence_listener
        obj.call
        expect(persistence_listener.called).must_equal 1
      end
    end # describe 'broadcasts the message'
  end # describe 'has a #call method that'
end
