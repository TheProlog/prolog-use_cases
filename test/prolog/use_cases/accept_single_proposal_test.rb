# frozen_string_literal: true

require 'test_helper'
require 'matchers/raise_with_message_part'
require 'matchers/requires_initialize_parameter'

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
    let(:proposal) { Struct.new(:article).new 'FIXME: PROPOSAL ARTICLE' }

    describe 'when called with a fully-valid :proposal parameter' do
      describe 'returns a Result object with' do
        it 'no :errors' do
          expect(call_result.errors).must_be :empty?
        end

        it 'an :original_proposal matching the passed-in proposal' do
          expect(call_result.original_proposal).must_equal proposal
        end

        it 'an :article attribute' do
          # FIXME: Lame spec for "what is an Article instance?"
          expect(call_result.article).must_respond_to :body
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
