# frozen_string_literal: true

require 'test_helper'
require 'ffaker'
require 'dry-equalizer'

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
      error = expect { described_class.new }.must_raise ArgumentError
      expected = 'missing keywords: authoriser, repository'
      expect(error.message).must_equal expected
    end
  end # describe 'has initialisation that'

  describe 'has a #call method that' do
    let(:obj) { described_class.new authoriser: auth, repository: repo }

    it 'requires an :author_name parameter' do
      repo = repo_class.new([])
      obj = described_class.new authoriser: Object.new, repository: repo
      error = expect { obj.call }.must_raise ArgumentError
      expect(error.message).must_equal 'missing keyword: author_name'
    end

    describe 'when called' do
      let(:author_name) { 'J Random Author' }
      let(:auth) { 'authoriser' }
      let(:call_result) { obj.call author_name: author_name }
      let(:article_count) { 8 }
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
      let(:repo) { repo_class.new(articles) }

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

          it 'a successful result' do
            expect(call_result).must_be :success?
          end

          it 'no articles' do
            expect(call_result.articles).must_be :empty?
          end

          it 'no errors' do
            expect(call_result.errors).must_be :empty?
          end

          it 'no keywords' do
            expect(call_result.keywords).must_be :empty?
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

          it 'a successful result' do
            expect(call_result).must_be :success?
          end

          it 'articles' do
            expect(call_result.articles).must_equal articles
          end

          it 'no errors' do
            expect(call_result.errors).must_be :empty?
          end

          it 'keywords associated with all articles' do
            expected = keywords.to_a.sort
            actual = call_result.keywords.to_a
            expect(actual).must_equal expected
          end
        end # describe 'with draft articles only, it correctly reports'

        describe 'with published articles only, it correctly reports' do
          let(:articles) do
            draft_articles.map { |draft| article_class.publish article: draft }
          end

          it 'a successful result' do
            expect(call_result).must_be :success?
          end

          it 'articles' do
            expect(call_result.articles).must_equal articles
          end

          it 'no errors' do
            expect(call_result.errors).must_be :empty?
          end

          it 'keywords associated with all articles' do
            expected = keywords.to_a.sort
            actual = call_result.keywords.to_a
            expect(actual).must_equal expected
          end
        end # describe 'with published articles only, it correctly reports'

        describe 'with both published and draft articles' do
          let(:articles) do
            draft_articles.map do |draft|
              if rand(0..1000).odd?
                draft
              else
                article_class.publish article: draft
              end
            end
          end

          it 'a successful result' do
            expect(call_result).must_be :success?
          end

          it 'articles' do
            expect(call_result.articles).must_equal articles
          end

          it 'no errors' do
            expect(call_result.errors).must_be :empty?
          end

          it 'keywords associated with all articles' do
            expected = keywords.to_a.sort
            actual = call_result.keywords.to_a
            expect(actual).must_equal expected
          end
        end # describe 'with both published and draft articles'
      end # describe 'by the specified author'

      describe 'by a user other than the specified author' do
        describe 'with no articles at all, it correctly reports' do
          it 'no articles'

          it 'no keywords'
        end # describe 'with no articles at all, it correctly reports'

        describe 'with published articles only, it correctly reports' do
          it 'articles'

          it 'keywords associated with all articles'
        end # describe 'with published articles only, it correctly reports'

        describe 'with draft articles only, it correctly reports' do
          it 'no articles'

          it 'no keywords'
        end # describe 'with draft articles only, it correctly reports'

        describe 'with both published and draft articles' do
          it 'published articles only'

          it 'keywords associated with all published articles'
        end # describe 'with both published and draft articles'
      end # describe 'by a user other than the specified author'
    end # describe 'when called'
  end # describe 'has a #call method that'
end
