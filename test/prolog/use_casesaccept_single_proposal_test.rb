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
end
