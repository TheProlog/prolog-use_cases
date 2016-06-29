# frozen_string_literal: true

require 'test_helper'

require 'matchers/requires_initialize_parameter'
require 'prolog/entities/contribution/accepted'
require 'prolog/entities/contribution/proposed'

require 'prolog/use_cases/authorise_contribution_response'

describe 'Prolog::UseCases::AuthoriseContributionResponse' do
  let(:described_class) { Prolog::UseCases::AuthoriseContributionResponse }
  let(:init_params) do
    { article_repo: article_repo, authoriser: authoriser,
      contribution_repo: contribution_repo }
  end
  let(:article_repo) { repo_class.new found_articles }
  let(:found_articles) { [] }
  let(:authoriser) do
    Struct.new(:current_user, :guest?).new current_user, is_guest
  end
  let(:current_user) { 'Guest User' }
  let(:is_guest) { current_user == 'Guest User' }
  let(:repo_class) do
    Class.new do
      attr_reader :find_params

      def initialize(results)
        @results = results
        @find_params = []
      end

      def add(entry)
      end

      def create(**params)
        Prolog::Entities::Contribution::Accepted.new params
      end

      def find(*params)
        find_params << params
        @results
      end
    end
  end
  # NOTE: This is being used for both Proposed and Accepted Contributions; we'd
  #       need some common table format for the two.
  let(:contribution_repo) { repo_class.new found_contributions }
  let(:found_contributions) { [] }

  describe 'initialisation' do
    let(:params) { init_params }

    describe 'requires a parameter value for' do
      [:article_repo, :authoriser, :contribution_repo].each do |param|
        it ":#{param}" do
          expect(described_class).must_require_initialize_parameter params,
                                                                    param
        end
      end
    end # describe 'requires a parameter value for'

    it 'succeeds when values for all parameters are specified' do
      expect(described_class.new params).must_be_instance_of described_class
    end
  end # describe 'initialisation'

  describe 'has a #call method that' do
    let(:obj) { described_class.new init_params }
    let(:call_method) { obj.method :call }
    let(:proposal) { proposal_class.new proposal_params }
    let(:proposal_class) { Prolog::Entities::Contribution::Proposed }
    let(:proposal_params) do
      { article_id: article_id, original_content: original_content,
        proposed_content: proposed_content, proposer: proposer,
        justification: justification, proposed_at: proposed_at,
        identifier: identifier }
    end
    let(:artid_class) { Prolog::Entities::ArticleIdentV }
    let(:article_id) { artid_class.new title: title, author_name: author_name }
    let(:title) { 'A Title' }
    let(:author_name) { 'T Random Author' }
    let(:body_content) { '<p>This is content.</p>' }
    let(:endpoints) { (3..18) } # 'T'..'.'
    let(:original_content) { body_content[endpoints] }
    let(:proposed_content) { 'This is <em>updated</em> content.' }
    let(:proposer) { 'J Random Proposer' }
    let(:justification) { nil } # defaults to empty string
    let(:proposed_at) { nil } # defaults to `DateTime.now` at instantiation
    let(:identifier) { UUID.generate }

    it 'requires a :proposal keyword parameter' do
      expect(call_method.parameters).must_equal [[:keyreq, :proposal]]
    end

    describe 'when called with a fully-valid :proposal parameter' do
      let(:current_user) { proposal.author_name }

      describe 'returns a Result object with' do
        let(:call_result) { obj.call proposal: proposal }

        it 'no errors' do
          expect(call_result.errors).must_be :empty?
        end

        it 'a #success? method returning true' do
          expect(call_result).must_be :success?
        end
      end # describe 'returns a Result object with'
    end # describe 'when called with a fully-valid :proposal parameter'

    describe 'reports failure when' do
      describe 'the current (logged-in) member is not the article author but' do
        let(:not_author) { [{ current_user: :not_author }] }

        describe 'is a different Member' do
          let(:current_user) { 'A Nother Member' }
          let(:call_result) { obj.call proposal: proposal }

          it 'has the correct entry in the #errors array' do
            expect(call_result.errors).must_equal not_author
          end

          it 'returns false from the #success? method' do
            expect(call_result).wont_be :success?
          end
        end # describe 'is a different Member'

        describe 'is the Guest User' do
          let(:call_result) { obj.call proposal: proposal }

          it 'has the correct entry in the #errors array' do
            expect(call_result.errors).must_equal not_author
          end

          it 'returns false from the #success? method' do
            expect(call_result).wont_be :success?
          end
        end # describe 'is a different Member'
      end # describe 'the current ... member is not the article author but'

      describe 'the proposal has already been responded to' do
        let(:call_result) { obj.call proposal: proposal }
        let(:current_user) { proposal.author_name }
        let(:new_id) { UUID.generate }

        before do
          q = body_content.dup # q is not frozen
          mtp = %(<a id="contribution-#{new_id}"></a>)
          q[endpoints] = mtp + proposed_content
          contrib_params = { article_id: proposal.article_id,
                             identifier: new_id,
                             proposal_id: proposal.identifier,
                             updated_body: q.freeze,
                             responded_at: nil, response_text: nil }
          contrib = contribution_repo.create contrib_params
          contribution_repo.instance_variable_get(:@results) << contrib
        end

        describe 'has only a Hash-like entry in the #errors array with' do
          it 'a single entry' do
            expect(call_result.errors.count).must_equal 1
          end

          it 'a key of :contribution_responded_to' do
            actual = call_result.errors.first.keys.first
            expect(actual).must_equal :contribution_responded_to
          end

          it 'a value that is a UUID' do
            actual = call_result.errors.first.values.first
            expect(actual).must_equal new_id
          end
        end # 'has only an entry in the #errors array with'

        it 'returns false from the #success? method' do
          expect(call_result).wont_be :success?
        end
      end # describe 'the proposal has already been responded to'
    end # describe 'reports failure when'
  end # describe 'has a #call method that'
end
