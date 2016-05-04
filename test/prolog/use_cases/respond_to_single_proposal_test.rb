# frozen_string_literal: true

require 'test_helper'
require 'matchers/raise_with_message'
require 'matchers/raise_with_message_part'

require 'prolog/use_cases/respond_to_single_proposal'

describe 'Prolog::UseCases::RespondToSingleProposal' do
  let(:described_class) { Prolog::UseCases::RespondToSingleProposal }

  describe 'initialisation' do
    let(:params) do
      { article_repo: Object.new, authoriser: Object.new,
        contribution_repo: Object.new }
    end

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
    let(:obj) { described_class.new init_params }
    let(:init_params) do
      { article_repo: article_repo, authoriser: authoriser,
        contribution_repo: contribution_repo }
    end
    let(:article_repo) { Object.new }
    let(:authoriser) { Object.new }
    let(:contribution_repo) { Object.new }
    let(:call_params) { { proposal: proposal } }
    let(:proposal) { Object.new }

    describe 'when called' do
      it 'without a :proposal parameter, raises an error' do
        message = 'missing keyword: proposal'
        expect { obj.call }.must_raise_with_message message
      end

      it 'with a valid :proposal parameter, returns a Result instance' do
        result_class = described_class.const_get(:Result)
        expect(obj.call call_params).must_be_instance_of result_class
      end
    end # describe 'when called'
  end # describe 'has a #call method that'
end
