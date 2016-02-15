
require 'test_helper'

require 'prolog/core'
require 'prolog/use_cases/summarise_content'

describe 'Prolog::UseCases::SummariseContent' do
  let(:described_class) { Prolog::UseCases::SummariseContent }
  let(:all_articles) { YAML.load_file 'test/fixtures/articles.yaml' }
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
  let(:obj) { described_class.new }

  it 'has a #call instance method taking no parameters' do
    method = obj.method(:call)
    expect(method.arity).must_equal 0
  end

  description = 'when a persistence listener is set up properly, #call' \
    ' returns a Hash'
  describe description do
    let(:summary) { obj.call }

    before :each do
      obj.subscribe persistence_listener
    end

    it 'with non-empty values' do
      empties = summary.values.reject { |item| !item.empty? }
      expect(empties).must_be :empty?
    end

    it 'with the correct four keys' do
      expected = [:articles, :keywords_by_frequency, :most_recent_articles,
                  :most_recently_updated_articles]
      expect(summary.keys).must_equal expected
    end

    describe 'which has an :articles array value with' do
      let(:articles) { summary[:articles] }

      it 'the correct number of articles' do
        expect(articles.count).must_equal all_articles.count
      end

      describe 'articles not sorted by' do
        after do
          ordered = @timestamps.sort
          in_order = @timestamps == ordered || @timestamps == ordered.reverse
          expect(in_order).must_equal false
        end

        it 'creation timestamp' do
          @timestamps = articles.map(&:created_at)
        end

        it 'update timestamp' do
          @timestamps = articles.map(&:updated_at)
        end
      end # describe 'articles not sorted by'
    end # describe 'which has an :articles array value with'

    describe 'which has a :keywords_by_frequency Hash value with' do
      let(:kw_freqs) { summary[:keywords_by_frequency] }

      it 'integers as keys' do
        others = kw_freqs.keys.reject { |key| key.is_a?(Integer) }
        expect(others).must_be :empty?
      end

      it 'keys in increasing-value order' do
        expect(kw_freqs.keys).must_equal kw_freqs.keys.sort
      end

      it 'values as sorted arrays' do
        others = kw_freqs.values.select { |list| list != list.sort }
        expect(others).must_be :empty?
      end
    end # describe 'which has a :keywords_by_frequency Hash value with'

    describe 'which has a :most_recent_articles array value with' do
      let(:mra) { summary[:most_recent_articles] }

      it 'articles sorted by creation timestamp, most recent first' do
        timestamps = mra.map(&:created_at)
        expect(timestamps).must_equal timestamps.sort.reverse
      end

      it 'the same articles as in the list of :articles' do
        expected = summary[:articles].sort_by(&:created_at).reverse
        expect(mra).must_equal expected
      end
    end # describe 'which has a :most_recent_articles array value with'

    describe 'which has a :most_recently_updated_articles array value with' do
      let(:mru) { summary[:most_recently_updated_articles] }

      it 'articles sorted by update timestamp, most recent first' do
        timestamps = mru.map(&:updated_at)
        expect(timestamps).must_equal timestamps.sort.reverse
      end

      it 'the same articles as in the list of :articles' do
        expected = summary[:articles].sort_by(&:updated_at).reverse
        expect(mru).must_equal expected
      end
    end # describe '...a :most_recently_updated_articles array value with'
  end # 'when a persistence listener is set up properly, #call returns a Hash'

  describe 'when, in error, no listener is active before calling #call' do
    it 'returns a Hash with empty values' do
      all_values = obj.call.reject { |data| !data || !data.empty? }
      expect(all_values).must_be :empty?
    end
  end # describe 'when, in error, no listener is active before calling #call'
end
