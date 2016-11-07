# frozen_string_literal: true

require 'test_helper'

require 'prolog/core'
require 'prolog/use_cases/summarise_content'

describe 'Prolog::UseCases::SummariseContent' do
  let(:described_class) { Prolog::UseCases::SummariseContent }
  let(:all_articles) { YAML.load_file 'test/fixtures/articles.yaml' }
  let(:obj) { described_class.new repository: article_repo }
  let(:current_user_name) { 'Guest User' }
  let(:article_repo) do
    Class.new do
      def initialize(articles)
        @articles = articles
        @articles.freeze
        self
      end

      def all
        @articles
      end

      private

      attr_reader :articles
    end.new(all_articles)
  end

  it 'must be initialised with a :repository parameter' do
    error = expect { described_class.new }.must_raise ArgumentError
    expect(error.message).must_equal 'missing keyword: repository'
  end

  it 'has a #call instance method taking no parameters' do
    method = obj.method(:call)
    expect(method.arity).must_equal 0
  end

  describe 'has a #call method that' do
    it 'returns a Hash with four entries' do
      expect(obj.call.keys.count).must_equal 4
    end

    describe 'returns a Hash with' do
      let(:return_value) { obj.call }

      it 'an :articles entry containing an array of Article entities' do
        others = return_value[:articles].reject do |item|
          item.is_a? Prolog::Core::Article
        end
        expect(others).must_be :empty?
      end

      describe 'a :keywords_by_frequency Hash with' do
        let(:kbf) { return_value[:keywords_by_frequency] }

        it 'non-zero integer values as keys' do
          others = kbf.keys.reject { |key| key.is_a?(Integer) && key.positive? }
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
