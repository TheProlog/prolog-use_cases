
require 'test_helper'

require 'prolog/core'
require 'prolog/use_cases/summarise_content'

describe 'Prolog::UseCases::SummariseContent' do
  let(:described_class) { Prolog::UseCases::SummariseContent }
  let(:all_articles) { YAML.load_file 'test/fixtures/articles.yaml' }
  let(:obj) { described_class.new }
  let(:current_user_name) { 'Guest User' }
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

    it 'returns a Hash with four entries' do
      obj.subscribe persistence_listener
      expect(obj.call.keys.count).must_equal 4
    end

    describe 'returns a Hash with' do
      let(:return_value) { obj.call }

      before do
        obj.subscribe persistence_listener
      end

      it 'an :articles entry containing an array of Article entities' do
        others = return_value[:articles].reject do |item|
          item.is_a? Prolog::Core::Article
        end
        expect(others).must_be :empty?
      end

      describe 'a :keywords_by_frequency Hash with' do
        let(:kbf) { return_value[:keywords_by_frequency] }

        it 'non-zero integer values as keys' do
          others = kbf.keys.reject { |key| key.is_a?(Fixnum) && key > 0 }
          expect(others).must_be :empty?
        end

        it 'ascending integer values as keys' do
          expect(kbf.keys).must_equal kbf.keys.sort
        end

        it 'an array of strings as the values' do
          others = []
          kbf.values.each do |entry|
            others << entry.reject { |value| value.is_a? String }
          end
          expect(others.flatten).must_be :empty?
        end

        it 'a sorted array of strings as the value' do
          all_sorted = kbf.values.inject(true) do |accum, entry|
            accum && entry == entry.sort
          end
          expect(all_sorted).must_equal true
        end
      end # describe 'a :keywords_by_frequency Hash with'

      describe 'a :most_recent_articles array with' do
        let(:mra) { return_value[:most_recent_articles] }

        it 'an array of Prolog::Core::Article instances' do
          others = mra.reject { |item| item.is_a? Prolog::Core::Article }
          expect(others).must_be :empty?
        end

        it 'an array sorted by created-at timestamps in descending order' do
          stamps = mra.map(&:created_at)
          expect(stamps).must_equal stamps.sort.reverse
        end
      end # describe 'a :most_recent_articles array with'

      describe 'a :most_recently_updated_articles array with' do
        let(:mru) { return_value[:most_recently_updated_articles] }

        it 'an array of Prolog::Core::Article instances' do
          others = mru.reject { |item| item.is_a? Prolog::Core::Article }
          expect(others).must_be :empty?
        end

        it 'an array sorted by updated-at timestamps in descending order' do
          stamps = mru.map(&:updated_at)
          expect(stamps).must_equal stamps.sort.reverse
        end
      end # describe 'a :most_recently_updated_articles array with'
    end # describe 'returns a Hash with'
  end # describe 'has a #call method that'
end
