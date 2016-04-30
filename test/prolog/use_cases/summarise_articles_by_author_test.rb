# frozen_string_literal: true

require 'test_helper'

require 'prolog/use_cases/summarise_articles_by_author'

describe 'Prolog::UseCases::SummariseArticlesByAuthor' do
  let(:described_class) { Prolog::UseCases::SummariseArticlesByAuthor }

  describe 'has initialisation that' do
    it 'requires two named parameters: :authoriser and :repository' do
      error = expect { described_class.new }.must_raise ArgumentError
      expected = 'missing keywords: authoriser, repository'
      expect(error.message).must_equal expected
    end
  end # describe 'has initialisation that'

  describe 'has a #call method that' do
    let(:obj) { described_class.new authoriser: auth, repository: repo }
    let(:auth) { 'authoriser' }
    let(:repo) { 'repo' }

    it 'requires an :author_name parameter' do
      error = expect { obj.call }.must_raise ArgumentError
      expect(error.message).must_equal 'missing keyword: author_name'
    end

    describe 'when called' do
      describe 'by the specified author' do
        describe 'with no articles at all, it correctly reports' do
          it 'no articles'

          it 'no keywords'
        end # describe 'with no articles at all, it correctly reports'

        describe 'with published articles only, it correctly reports' do
          it 'articles'

          it 'keywords associated with all articles'
        end # describe 'with published articles only, it correctly reports'

        describe 'with draft articles only, it correctly reports' do
          it 'articles'

          it 'keywords associated with all articles'
        end # describe 'with draft articles only, it correctly reports'

        describe 'with both published and draft articles' do
          it 'articles'

          it 'keywords associated with all articles'
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
