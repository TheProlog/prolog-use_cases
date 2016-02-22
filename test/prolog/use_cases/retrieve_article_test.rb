
require 'test_helper'

require 'prolog/use_cases/retrieve_article'

describe 'Prolog::UseCases::RetrieveArticle' do
  let(:described_class) { Prolog::UseCases::RetrieveArticle }
  let(:authoriser) { Struct.new(:guest?, :current_user).new false, 'User Name' }
  let(:init_params) { { repository: repository, authoriser: authoriser } }
  let(:obj) { described_class.new init_params }
  let(:repository) { :irrelevant }

  describe 'must be initialised with a named parameter value for' do
    after do
      init_params.delete @param
      error = expect do
        described_class.new init_params
      end.must_raise ArgumentError
      expect(error.message).must_equal "missing keyword: #{@param}"
    end

    it ':repository' do
      @param = :repository
    end

    it ':authoriser' do
      @param = :authoriser
    end
  end # describe 'must be initialised with a named parameter value for'

  describe 'has a #call instance method that' do
    let(:dummy_article) do
      Prolog::Core::Article.new title: title, body: 'Body Text',
                                keywords: [], author_name: author_name
    end
    let(:author_name) { 'Author Name' }
    let(:title) { 'Sample Title' }
    let(:params) do
      { title: title, author: author_name, repository: repository }
    end
    let(:repository) do
      Class.new do
        def initialize(result:)
          @result = result
          @called_with = []
        end

        def where(**_params)
          [@result].flatten
        end
      end.new result: result
    end
    let(:result) { :irrelevant }

    it 'takes one parameter, marked as a "variable number of arguments"' do
      method = obj.method :call
      expect(method.arity).must_equal(-1)
    end

    describe 'when called with' do
      let(:result) { dummy_article }
      let(:return_value) { obj.call params }

      describe 'search terms matching a single existing Article, it' do
        it 'retrieves a Prolog::Core::Article instance' do
          expect(return_value).must_be_instance_of Prolog::Core::Article
        end

        it 'retrieves the matching article' do
          expect(return_value).must_equal result
        end
      end # describe 'search terms  matching a single existing Article, it'

      describe 'an empty hash, it' do
        let(:params) { {} }

        it 'returns :invalid_repository as an error indication' do
          expect(return_value).must_equal :invalid_repository
        end
      end # describe 'an empty hash, it'

      describe 'a Hash containing only a repository that is valid and' do
        let(:params) { { repository: repository } }

        describe 'empty' do
          let(:result) { [] }

          it 'returns :non_specific_search_terms as an error indicator' do
            expect(return_value).must_equal :non_specific_search_terms
          end
        end # describe 'empty'

        describe 'contains only a single Article' do
          let(:result) { [dummy_article] }

          it 'returns that single Article' do
            expect(return_value).must_equal dummy_article
          end
        end # describe 'contains only a single Article'

        describe 'contains multiple Articles' do
          let(:result) { [dummy_article, dummy_article] }

          it 'returns :non_specific_search_terms as an error indicator' do
            expect(return_value).must_equal :non_specific_search_terms
          end
        end # describe 'contains multiple Articles'
      end # describe 'a Hash containing only a repository that is valid and'
    end # describe 'when called with'
  end # describe 'has a #call instance method that'
end
