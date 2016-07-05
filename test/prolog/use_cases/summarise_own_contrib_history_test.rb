# frozen_string_literal: true

require 'test_helper'

require 'matchers/requires_initialize_parameter'

require 'prolog/use_cases/summarise_own_contrib_history'

describe 'Prolog::UseCases::SummariseOwnContribHistory' do
  let(:described_class) { Prolog::UseCases::SummariseOwnContribHistory }
  let(:authoriser) do
    Struct.new(:guest?, :user_name).new is_guest, user_name
  end
  let(:call_params) do
    { authoriser: authoriser, contribution_repo: contribution_repo }
  end
  let(:contribution_repo) { :dummy_contribution_repo }
  let(:guest_name) { 'Guest User' }
  let(:is_guest) { user_name == guest_name }
  let(:user_name) { 'M Random Member' }

  describe 'has a .call method that' do
    [:authoriser, :contribution_repo].each do |attrib|
      it "requires an :#{attrib} parameter" do
        call_params.delete attrib
        expect { described_class.call call_params }.must_raise ArgumentError
      end
    end

    it 'succeeds when valid required parameters are specified' do
      expect { described_class.call call_params }.must_be_silent
    end
  end # describe 'has a .call method that'
end
