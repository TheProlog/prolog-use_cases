# frozen_string_literal: true

require 'test_helper'
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
      expect { described_class.new params }.must_be_silent
    end
  end # describe 'initialisation'
end
