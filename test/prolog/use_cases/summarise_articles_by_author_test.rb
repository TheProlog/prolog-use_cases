# frozen_string_literal: true

require 'test_helper'
require 'ffaker'
require 'dry-equalizer'

require 'matchers/keywords_as_expected'
require 'matchers/raise_with_message'
require 'matchers/success_with_no_errors'

require 'prolog/use_cases/summarise_articles_by_author'

describe 'Prolog::UseCases::SummariseArticlesByAuthor' do
  let(:described_class) { Prolog::UseCases::SummariseArticlesByAuthor }
  let(:article_class) do
    Class.new do
      include Dry::Equalizer :author_name, :body, :keywords, :published_at,
                             :title

      attr_reader :author_name, :body, :keywords, :published_at, :title

      def initialize(author_name:, title:, body:, keywords: [],
                     published_at: nil)
        @author_name = author_name
        @body = body
        @title = title
        @keywords = keywords
        @published_at = published_at
        self
      end

      def published?
        published_at.respond_to?(:hour)
      end

      def to_hash
        { author_name: author_name, body: body, keywords: keywords,
          published_at: published_at, title: title }
      end

      def self.publish(article:, published_at: DateTime.now)
        params = article.to_hash.merge(published_at: published_at)
        article.class.new params
      end
    end
  end
  let(:authoriser_class) { Struct.new(:current_user, :guest?) }
  let(:repo_class) do
    Class.new do
      attr_reader :find_params

      def initialize(articles)
        @articles = articles
        @find_params = []
        self
      end

      def find(**params)
        @find_params << params
        @articles
      end
    end
  end

  describe 'has initialisation that' do
    it 'requires two named parameters: :authoriser and :repository' do
      expected = 'missing keywords: authoriser, repository'
      expect { described_class.new }.must_raise_with_message expected
    end
  end # describe 'has initialisation that'

  describe 'has a #call method that' do
    let(:obj) { described_class.new authoriser: auth, repository: repo }
    let(:article_count) { 8 }
    let(:author_name) { 'J Random Author' }
    let(:call_result) { obj.call author_name: author_name }
    let(:draft_articles) do
      Array.new(article_count) do
        hip = FFaker.const_get(:HipsterIpsum)
        word_count = rand(0..5)
        params = { title: hip.phrase, body: hip.paragraph,
                   keywords: hip.words(word_count),
                   author_name: author_name }
        article_class.new params
      end
    end
    let(:keywords) do
      Set.new articles.map(&:keywords).flatten
    end
    let(:mixed_articles) do
      draft_articles.map do |draft|
        if rand(0..1000).odd?
          draft
        else
          article_class.publish article: draft
        end
      end
    end
    let(:published_articles) do
      draft_articles.map { |draft| article_class.publish article: draft }
    end
    let(:repo) { repo_class.new(articles) }

    it 'requires an :author_name parameter' do
      repo = repo_class.new([])
      obj = described_class.new authoriser: Object.new, repository: repo
      expect { obj.call }.must_raise_with_message 'missing keyword: author_name'
    end

    describe 'when called' do
      describe 'by the specified author' do
        let(:auth) { authoriser_class.new author_name, false }

        describe 'with no articles at all, it correctly' do
          let(:articles) { [] }

          describe 'calls the repository #find method' do
            before { _ = call_result }

            it 'once' do
              expect(repo.find_params.count).must_equal 1
            end

            it 'with the author name parameter' do
              actual = repo.find_params.first
              expect(actual).must_equal(author_name: author_name)
            end
          end # describe 'calls the repository #find method'

          it 'a successful result with no errors' do
            expect(obj).must_be_success_with_no_errors(author_name)
          end

          it 'no articles' do
            expect(call_result.articles).must_be :empty?
          end

          it 'no keywords' do
            expect(obj).must_have_keywords_as_expected([], author_name)
          end
        end # describe 'with no articles at all, it correctly'

        describe 'with draft articles only, it correctly reports' do
          let(:articles) { draft_articles }

          describe 'calls the repository #find method' do
            before { _ = call_result }

            it 'once' do
              expect(repo.find_params.count).must_equal 1
            end

            it 'with the author name parameter' do
              actual = repo.find_params.first
              expect(actual).must_equal(author_name: author_name)
            end
          end # describe 'calls the repository #find method'

          it 'a successful result with no errors' do
            expect(obj).must_be_success_with_no_errors(author_name)
          end

          it 'articles' do
            expect(call_result.articles).must_equal articles
          end

          it 'keywords associated with all articles' do
            expect(obj).must_have_keywords_as_expected(keywords, author_name)
          end
        end # describe 'with draft articles only, it correctly reports'

        describe 'with published articles only, it correctly reports' do
          let(:articles) { published_articles }

          it 'a successful result with no errors' do
            expect(obj).must_be_success_with_no_errors(author_name)
          end

          it 'articles' do
            expect(call_result.articles).must_equal articles
          end

          it 'keywords associated with all articles' do
            expect(obj).must_have_keywords_as_expected(keywords, author_name)
          end
        end # describe 'with published articles only, it correctly reports'

        describe 'with both published and draft articles, correctly reports' do
          let(:articles) { mixed_articles }

          it 'a successful result with no errors' do
            expect(obj).must_be_success_with_no_errors(author_name)
          end

          it 'articles' do
            expect(call_result.articles).must_equal articles
          end

          it 'keywords associated with all articles' do
            expect(obj).must_have_keywords_as_expected(keywords, author_name)
          end
        end # describe 'with both published and draft articles, ... reports'
      end # describe 'by the specified author'

      describe 'by a user other than the specified author' do
        let(:auth) { authoriser_class.new 'J Other Member', false }

        describe 'with no articles at all, it correctly' do
          let(:articles) { [] }

          describe 'calls the repository #find method' do
            before { _ = call_result }

            it 'once' do
              expect(repo.find_params.count).must_equal 1
            end

            it 'with the author name parameter' do
              actual = repo.find_params.first
              expect(actual).must_equal(author_name: author_name)
            end
          end # describe 'calls the repository #find method'

          it 'a successful result with no errors' do
            expect(obj).must_be_success_with_no_errors(author_name)
          end

          it 'no articles' do
            expect(call_result.articles).must_be :empty?
          end

          it 'no keywords' do
            expect(obj).must_have_keywords_as_expected([], author_name)
          end
        end # describe 'with no articles at all, it correctly'

        describe 'with draft articles only, it correctly' do
          let(:articles) { draft_articles }

          describe 'calls the repository #find method' do
            before { _ = call_result }

            it 'once' do
              expect(repo.find_params.count).must_equal 1
            end

            it 'with the author name parameter' do
              actual = repo.find_params.first
              expect(actual).must_equal(author_name: author_name)
            end
          end # describe 'calls the repository #find method'

          it 'a successful result with no errors' do
            expect(obj).must_be_success_with_no_errors(author_name)
          end

          it 'no articles' do
            expect(call_result.articles).must_be :empty?
          end

          it 'no keywords' do
            expect(obj).must_have_keywords_as_expected([], author_name)
          end
        end # describe 'with draft articles only, it correctly'

        describe 'with published articles only, it correctly reports' do
          let(:articles) { published_articles }

          it 'a successful result with no errors' do
            expect(obj).must_be_success_with_no_errors(author_name)
          end

          it 'articles' do
            expect(call_result.articles).must_equal articles
          end

          it 'keywords associated with all articles' do
            expect(obj).must_have_keywords_as_expected(keywords, author_name)
          end
        end # describe 'with published articles only, it correctly reports'

        describe 'with both published and draft articles, correctly reports' do
          let(:articles) { mixed_articles }
          let(:keywords) do
            Set.new published_articles.map(&:keywords).flatten
          end
          let(:published_articles) do
            mixed_articles.select(&:published_at)
          end

          it 'a successful result with no errors' do
            expect(obj).must_be_success_with_no_errors(author_name)
          end

          it 'published articles only' do
            expect(call_result.articles).must_equal published_articles
          end

          it 'keywords associated with all articles' do
            expect(obj).must_have_keywords_as_expected(keywords, author_name)
          end
        end # describe 'with both published and draft articles, ... reports'
      end # describe 'by a user other than the specified author'
    end # describe 'when called'
  end # describe 'has a #call method that'
end
