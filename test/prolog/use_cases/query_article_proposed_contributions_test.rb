
require 'test_helper'

require 'prolog/use_cases/query_article_proposed_contributions'

GUEST_USER_NAME = 'Guest User'

describe 'Prolog::UseCases::QueryArticleProposedContributions' do
  let(:described_class) { Prolog::UseCases::QueryArticleProposedContributions }
  let(:article_repo) { repo_class.new found_articles }
  let(:found_articles) { :not_found }
  let(:repo_class) do
    Class.new do
      attr_reader :find_params

      def initialize(entities)
        @entities = entities
        @find_params = []
        self
      end

      def find(**params)
        find_params << params
        @entities
      end
    end
  end
  let(:authoriser) do
    is_guest = user_name == GUEST_USER_NAME
    Struct.new(:guest?, :user_name).new is_guest, user_name
  end
  let(:call_params) { { article_id: article_id } }
  let(:contribution_repo) { repo_class.new found_contributions }
  let(:found_contributions) { :not_found }
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
      let(:found_articles) { [article_id] }
      let(:obj) { described_class.new init_params }
      let(:title) { 'A Title' }
      let(:user_name) { 'J Random Author' }

      it 'reports a successful result' do
        expect(obj.call(call_params)).must_be :success?
      end

      it 'reports no errors' do
        expect(obj.call(call_params).errors).must_be :empty?
      end

      describe 'correctly reports contributions found when the member has' do
        describe 'not published articles' do
          let(:found_articles) { :not_found }

          it 'by reporting the result #proposals as an empty array' do
            expect(obj.call(call_params).proposals).must_be :empty?
          end
        end # describe 'not published articles'

        describe 'published articles that have' do
          let(:found_articles) { [article_id] }

          describe 'no submitted proposals active by reporting #proposals' do
            let(:found_contributions) { :not_found }

            it 'by reporting the result #proposals as an empty array' do
              expect(obj.call(call_params).proposals).must_be :empty?
            end
          end # describe 'no submitted proposals active by reporting #proposals'

          describe 'existing submitted proposals by reporting #proposals' do
            let(:contrib_class) { Prolog::Entities::Proposal }
            let(:endpoints) { (0..-1) }
            let(:justification) { 'Because we can.' }
            let(:proposed_content) { 'basic' }
            let(:found_contributions) do
              params = { article_id: article_id, proposer: 'Somebody Else',
                         endpoints: endpoints, justification: justification,
                         proposed_content: proposed_content }
              proposal = Prolog::Entities::Proposal.new params
              [proposal]
            end

            it 'containing the Proposal entities' do
              actual = obj.call(call_params).proposals
              expect(actual).must_equal found_contributions
            end
          end # describe 'existing submitted proposals by reporting #proposals'
        end # describe 'published articles that have'
      end # describe 'correctly reports contributions found when the member has'
    end # describe 'when initialised using valid parameter values and'
  end # describe 'has a #call method that'
end
