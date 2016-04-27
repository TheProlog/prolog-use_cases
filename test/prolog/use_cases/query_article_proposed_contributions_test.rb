
require 'test_helper'

require 'prolog/use_cases/query_article_proposed_contributions'

GUEST_USER_NAME = 'Guest User'

describe 'Prolog::UseCases::QueryArticleProposedContributions' do
  let(:described_class) { Prolog::UseCases::QueryArticleProposedContributions }
  let(:article_repo) { Object.new }
  let(:article_repo_class) do
    Class.new do
      attr_reader :find_params
      def initialize(article)
        @article = article
        @find_params = []
        self
      end

      def find(**params)
        find_params << params
        article
      end
    end
  end
  let(:authoriser) do
    is_guest = user_name == GUEST_USER_NAME
    Struct.new(:guest?, :user_name).new is_guest, user_name
  end
  let(:call_params) { { article_id: article_id } }
  let(:contribution_repo) { Object.new }
  let(:init_params) do
    { article_repo: article_repo, contribution_repo: contribution_repo,
      authoriser: authoriser }
  end
  let(:user_name) { GUEST_USER_NAME }

  describe 'initialisation' do
    describe 'requires specified keyword parameters for' do
      let(:init_method) { described_class.new(init_params).method :initialize }
      let(:required_params) { init_method.parameters }

      [:article_repo, :authoriser, :contribution_repo].each do |attrib|
        it ":#{attrib}" do
          expected = [:keyreq, attrib]
          expect(required_params).must_include expected
        end
      end
    end # describe 'requires specified keyword parameters for'
  end # describe 'initialisation'

  describe 'has a #call method that' do
    describe 'when initialised using valid parameter values and' do
      let(:article_id) do
        Prolog::Entities::ArticleIdent.new author_name: user_name, title: title
      end
      let(:article_repo) { article_repo_class.new found_article }
      let(:found_article) { article_id }
      let(:obj) { described_class.new init_params }
      let(:title) { 'A Title' }
      let(:user_name) { 'J Random Author' }

      it 'reports a successful result' do
        expect(obj.call(call_params)).must_be :success?
      end
    end # describe 'when initialised using valid parameter values and'
  end # describe 'has a #call method that'
end
