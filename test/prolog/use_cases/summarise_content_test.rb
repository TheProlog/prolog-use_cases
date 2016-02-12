
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
  end # describe 'has a #call method that'

  it 'has a #most_recently_updated_articles method' do
    expect(obj).must_respond_to :most_recently_updated_articles
  end

  describe 'has a #most_recently_updated_articles method that, when called' do
    describe 'without previously calling #call on that instance' do
      it 'returns an empty array' do
        expect(obj.most_recently_updated_articles).must_be :empty?
      end
    end # describe 'without previously calling #call on that instance'

    describe 'after calling a properly-set-up #call method returns' do
      let(:list) { obj.most_recently_updated_articles }

      before do
        obj.subscribe persistence_listener
        obj.call
      end

      it 'a list of Articles' do
        others = list.reject { |item| item.instance_of? Prolog::Core::Article }
        expect(others).must_be :empty?
      end

      it 'a list sorted by updated-at timestamp in reverse order' do
        actual = list.map(&:updated_at)
        expected = all_articles.map(&:updated_at).sort.reverse
        expect(actual).must_equal expected
      end
    end # describe 'after calling a properly-set-up #call method returns'
  end # describe 'has a #most_recently_updated_articles method that, ...'

  describe 'has a #most_recent_articles method that, when called' do
    describe 'without previously calling #call on that instance' do
      it 'returns an empty array' do
        expect(obj.most_recent_articles).must_be :empty?
      end
    end # describe 'without previously calling #call on that instance'

    describe 'after calling a properly-set-up #call method returns' do
      let(:list) { obj.most_recent_articles }

      before do
        obj.subscribe persistence_listener
        obj.call
      end

      it 'a list of Articles' do
        others = list.reject { |item| item.instance_of? Prolog::Core::Article }
        expect(others).must_be :empty?
      end

      it 'a list sorted by created-at timestamp in reverse order' do
        actual = list.map(&:created_at)
        expected = all_articles.map(&:created_at).sort.reverse
        expect(actual).must_equal expected
      end
    end # describe 'after calling a properly-set-up #call method returns'
  end # describe 'has a #most_recent_articles method that, when called'

  describe 'has a #keywords_by_frequency method that, when called' do
    describe 'without previously calling #call on that instance' do
      it 'returns an empty Hash' do
        expect(obj.keywords_by_frequency).must_equal({})
      end
    end # describe 'without previously calling #call on that instance'

    describe 'after calling a properly-set-up #call method returns' do
      let(:keywords) { obj.keywords_by_frequency }

      before do
        obj.subscribe persistence_listener
        obj.call
      end

      it 'a non-empty Hash' do
        expect(keywords.keys).wont_be :empty?
      end

      describe 'a Hash with' do
        it 'positive integers as keys' do
          expected = keywords.keys.select { |key| key.is_a? Fixnum }
                     .select { |key| key > 0 }
          expect(keywords.keys).must_equal expected
        end

        it 'arrays of strings as values' do
          expected = keywords.values.select { |value| value.is_a? Array }
                     .select do |values|
            values.reject { |value| value.is_a? String }
            .empty?
          end
          expect(keywords.values).must_equal expected
        end

        it 'values containing unique strings' do
          all_keywords = keywords.values.flatten
          expect(all_keywords).must_equal all_keywords.uniq
        end
      end # describe 'a Hash with'
    end # describe 'after calling a properly-set-up #call method returns'
  end # describe 'has a #keywords_by_frequency method that, when called'
end
