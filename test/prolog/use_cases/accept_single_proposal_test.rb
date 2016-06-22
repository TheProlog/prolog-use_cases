# frozen_string_literal: true

require 'test_helper'
require 'matchers/raise_with_message_part'
require 'matchers/requires_initialize_parameter'

require 'prolog/entities/contribution/proposed'

require 'prolog/use_cases/accept_single_proposal'

describe 'Prolog::UseCases::AcceptSingleProposal' do
  let(:described_class) { Prolog::UseCases::AcceptSingleProposal }
  let(:init_params) do
    { article_repo: article_repo, authoriser: authoriser,
      contribution_repo: contribution_repo }
  end
  let(:article_repo) { 'Article Repo' }
  let(:authoriser) do
    Struct.new(:current_user, :guest?).new current_user, is_guest
  end
  let(:current_user) { 'Guest User' }
  let(:is_guest) { current_user == 'Guest User' }
  let(:contribution_repo) do
    Class.new do
      attr_reader :find_params

      def initialize(results)
        @results = results
        @find_params = []
      end

      # def find(*params)
      #   find_params << params
      #   @results
      # end
    end.new found_contributions
  end
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
    let(:call_params) { { proposal: proposal } }
    let(:call_result) { obj.call call_params }
    let(:proposal) { proposal_class.new proposal_params }
    let(:proposal_class) { Prolog::Entities::Contribution::Proposed }
    let(:proposal_params) do
      { article_id: article_id, original_content: article.body[endpoints],
        proposed_content: proposed_content, proposer: proposer,
        justification: justification, proposed_at: proposed_at,
        identifier: identifier }
    end
    let(:artid_class) { Prolog::Entities::ArticleIdentV }
    let(:article_id) { artid_class.new title: title, author_name: author_name }
    let(:title) { 'A Title' }
    let(:author_name) { current_user }
    let(:body_content) { '<p>This is content.</p>' }
    let(:endpoints) { (3..18) } # 'T'..'.'
    let(:proposed_content) { 'This is <em>updated</em> content.' }
    let(:proposer) { 'J Random Proposer' }
    let(:justification) { nil } # defaults to empty string
    let(:proposed_at) { nil } # defaults to `DateTime.now` at instantiation
    let(:identifier) { nil } # defaults to generating a new UUID

    describe 'when called with a fully-valid :proposal parameter' do
      let(:article) do
        params = [author_name, body_content, title, article_id]
        Struct.new(:author_name, :body, :title, :article_id).new(*params).freeze
      end
      let(:article_repo) do
        Class.new do
          attr_reader :find_params

          def initialize(results)
            @results = results
            @find_params = []
          end

          def find(*params)
            find_params << params
            @results
          end
        end.new [article]
      end
      let(:current_user) { 'J Random Author' }

      describe 'returns a Result object with' do
        it 'no :errors' do
          expect(call_result.errors).must_be :empty?
        end

        it 'an :original_content attribute that is not empty' do
          expect(call_result.original_content).wont_be :empty?
        end

        # -- helper methods --

        it 'a #response of :accepted' do
          expect(call_result.response).must_equal :accepted
        end

        it 'an #accepted? method returning true' do
          expect(call_result).must_be :accepted?
        end

        it 'a #rejected? method returning false' do
          expect(call_result).wont_be :rejected?
        end

        it 'a #responded? method returning true' do
          expect(call_result).must_be :responded?
        end

        it 'a #success? method returning true' do
          expect(call_result).must_be :success?
        end
      end # describe 'returns a Result object with'
    end # describe 'when called with a fully-valid :proposal parameter'
  end # describe 'has a #call method that'
end
