# frozen_string_literal: true

require 'test_helper'
require 'matchers/raise_with_message_part'

require 'uuid'

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

      def find(*params)
        find_params << params
        @results
      end
    end.new found_contributions
  end
  let(:found_contributions) { [] }
  let(:call_params) { { proposal: proposal, responder: responder } }
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
  let(:call_result) { obj.call call_params }
  let(:proposal) do
    prop_class = Struct.new(:article_id, :author_name, :proposer, :identifier)
    prop_class.new article_id, author_name, proposer, contrib_id
  end
  let(:contrib_id) { UUID.generate }
  let(:article_id) do
    Struct.new(:author_name, :title).new author_name, title
  end
  let(:author_name) { 'An Author' }
  let(:proposer) { 'J Random Member' }
  let(:title) { 'A Title' }

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
      let(:current_user) { author_name }

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

    describe 'when preconditions are not met because' do
      describe 'the current user is not the author of the Article' do
        let(:current_user) { 'Another Member' }

        it 'reports an unsucccessful result' do
          expect(call_result).wont_be :success?
        end

        it 'reports not being responded to by this use case invocation' do
          expect(call_result).wont_be :responded?
        end
      end # describe 'the current user is not the author of the Article'

      describe 'the proposer of the Contribution is the current user' do
        let(:proposer) { author_name }
        let(:current_user) { author_name }

        it 'reports an unsucccessful result' do
          expect(call_result).wont_be :success?
        end

        it 'reports not being responded to by this use case invocation' do
          expect(call_result).wont_be :responded?
        end
      end # describe 'the proposer of the Contribution is the current user'

      describe 'the Proposal has already been Responded to' do
        let(:current_user) { author_name }
        let(:responded_contrib) { Struct.new(:responded_at).new DateTime.now }
        let(:found_contributions) { [responded_contrib] }

        it 'reports an unsucccessful result' do
          expect(call_result).wont_be :success?
        end

        it 'reports being previously responded to' do
          expected = { status: :responded }
          expect(call_result.errors).must_include expected
        end

        it 'reports not being responded to by this use case invocation' do
          expect(call_result).wont_be :responded?
        end
      end # describe 'the Proposal has already been Responded to'
    end # describe 'when preconditions are not met because'
  end # describe 'has a #call method that'
end
