# frozen_string_literal: true

require 'test_helper'
require 'matchers/raise_with_message_part'

require 'prolog/use_cases/respond_to_single_proposal'

describe 'Prolog::UseCases::RespondToSingleProposal' do
  let(:described_class) { Prolog::UseCases::RespondToSingleProposal }
  let(:result_class) { Prolog::UseCases::RespondToSingleProposal::Result }
  let(:obj) { described_class.new init_params }
  let(:init_params) do
    { article_repo: article_repo, authoriser: authoriser,
      contribution_repo: contribution_repo }
  end
  let(:article_repo) { Object.new }
  let(:authoriser) { Object.new }
  let(:contribution_repo) { Object.new }
  let(:call_params) { { proposal: proposal, responder: responder } }
  let(:proposal) { Object.new }
  let(:responder) do
    Class.new do
      attr_reader :call_params

      def initialize(response)
        @response = response
        @call_params = []
      end

      def call(*params)
        @call_params << params
        @response
      end
    end.new ui_response
  end
  let(:ui_response) { :accepted }

  describe 'initialisation' do
    let(:params) { init_params }

    describe 'requires parameters for' do
      [:article_repo, :authoriser, :contribution_repo].each do |attrib|
        it ":#{attrib}" do
          params.delete attrib
          exp = /missing keyword\:.*? #{attrib}/
          expect { described_class.new params }.must_raise_with_message_part exp
        end
      end
    end # describe 'requires parameters for'

    it 'succeeds when values for all parameters are specified' do
      expect(described_class.new params).must_be_instance_of described_class
    end
  end # describe 'initialisation'

  describe 'has a #call method that' do
    describe 'requires parameters for' do
      [:proposal, :responder].each do |attrib|
        it ":#{attrib}" do
          call_params.delete attrib
          exp = /missing keyword\:.*? #{attrib}/
          expect { obj.call call_params }.must_raise_with_message_part exp
        end
      end
    end # describe 'requires parameters for'

    it 'returns a Result object' do
      expect(obj.call call_params).must_be_instance_of result_class
    end

    describe 'when called with a valid proposal and a responder that' do
      let(:call_result) { obj.call call_params }

      describe 'indicates an :accepted response' do
        let(:ui_response) { :accepted }

        it 'reports a successful result' do
          expect(call_result).must_be :success?
        end

        it 'reports an :accepted response' do
          expect(call_result).must_be :accepted?
        end
      end # describe 'indicates an :accepted response'

      describe 'indicates a :rejected response' do
        let(:ui_response) { :rejected }

        it 'reports a successful result' do
          expect(call_result).must_be :success?
        end

        it 'reports a :rejected response' do
          expect(call_result).must_be :rejected?
        end
      end # describe 'indicates a :rejected response'
    end # describe 'when called with a valid proposal and a responder that'
  end # describe 'has a #call method that'
end
