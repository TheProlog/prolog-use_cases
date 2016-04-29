
require 'test_helper'

require 'prolog/use_cases/query_article_proposed_contributions'

GUEST_USER_NAME = 'Guest User'.freeze

describe 'Prolog::UseCases::QueryArticleProposedContributions' do
  let(:described_class) { Prolog::UseCases::QueryArticleProposedContributions }
  let(:article_id) do
    Prolog::Entities::ArticleIdent.new author_name: author_name,
                                       title: article_title
  end
  let(:article_title) { title }
  let(:title) { 'A Title' }
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
  let(:obj) { described_class.new init_params }
  let(:user_name) { GUEST_USER_NAME }
  let(:author_name) { user_name }

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
    describe 'on an instance initialised with' do
      describe 'valid parameter values, it' do
        let(:found_articles) { [article_id] }
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
            end # describe 'no ... proposals active by reporting #proposals'

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
            end # describe 'existing ... proposals by reporting #proposals'
          end # describe 'published articles that have'
        end # describe '... reports contributions found when the member has'
      end # describe 'valid parameter values, it'

      describe 'no Member presently logged in, it' do
        let(:user_name) { GUEST_USER_NAME }

        it 'reports failure' do
          expect(obj.call call_params).wont_be :success?
        end

        it 'reports an error that no user is logged in' do
          actual = obj.call(call_params).errors[:current_user]
          expect(actual).must_equal ['not logged in']
        end

        it 'returns no #proposals' do
          expect(obj.call(call_params).proposals).must_be :empty?
        end
      end # describe 'no Member presently logged in, it'

      describe 'a current user not the Author of the specified Article, it' do
        let(:author_name) { 'Marcus Tullius Cicero' }
        let(:user_name) { 'J Random User' }

        it 'reports failure' do
          expect(obj.call call_params).wont_be :success?
        end

        it 'reports an error that the current user is not the author' do
          actual = obj.call(call_params).errors[:current_user]
          expect(actual).must_equal ['not author']
        end

        it 'returns no #propoosals' do
          expect(obj.call(call_params).proposals).must_be :empty?
        end
      end # describe 'a ... user not the Author of the specified Article, it'

      describe 'no Article matching the specification is found' do
        let(:article_titlie) { 'Some Different Title; You Screwed Up' }
        let(:found_articles) { :not_found }
        let(:user_name) { 'J Random User' }

        it 'reports failure' do
          expect(obj.call call_params).wont_be :success?
        end

        it 'reports an error that the article was not found' do
          actual = obj.call(call_params).errors[:article]
          expect(actual).must_equal ['not found']
        end

        it 'returns no #propoosals' do
          expect(obj.call(call_params).proposals).must_be :empty?
        end
      end # describe 'no Article matching the specification is found'
    end # describe 'on an instance initialised with'
  end # describe 'has a #call method that'
end
