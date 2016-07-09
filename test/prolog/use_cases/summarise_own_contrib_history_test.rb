# frozen_string_literal: true

require 'test_helper'

require 'matchers/requires_initialize_parameter'

require 'prolog/entities/contribution/accepted'
require 'prolog/entities/contribution/proposed'
require 'prolog/entities/contribution/rejected'
require 'prolog/use_cases/summarise_own_contrib_history'

describe 'Prolog::UseCases::SummariseOwnContribHistory' do
  let(:described_class) { Prolog::UseCases::SummariseOwnContribHistory }
  let(:accepted_contributions) { [] }
  let(:authoriser) do
    Struct.new(:guest?, :user_name).new is_guest, user_name
  end
  let(:call_params) do
    { authoriser: authoriser, contribution_repo: contribution_repo }
  end
  let(:contribution_repo) do
    Class.new do
      def initialize(proposed: [], accepted: [], rejected: [])
        @data = {
          accepted: Array(accepted),
          proposed: Array(proposed),
          rejected: Array(rejected)
        }
        self
      end

      def find(**params)
        if [:accepted, :proposed, :rejected].include? params[:status]
          @data[params[:status]]
        else
          @data.values.flatten
        end
      end
    end.new proposed: proposed_contributions,
            accepted: accepted_contributions,
            rejected: rejected_contributions
  end
  let(:guest_name) { 'Guest User' }
  let(:is_guest) { user_name == guest_name }
  let(:proposed_contributions) { [] }
  let(:rejected_contributions) { [] }
  let(:user_name) { 'M Random Member' }

  describe 'has a .call method that' do
    [:authoriser, :contribution_repo].each do |attrib|
      it "requires an :#{attrib} parameter" do
        call_params.delete attrib
        expect { described_class.call call_params }.must_raise ArgumentError
      end
    end

    describe 'when the :authoriser indicates that a Member is logged in' do
      describe 'returns a result object that' do
        let(:call_result) { described_class.call call_params }

        it 'has an :errors attribute which is empty' do
          expect(call_result.errors).must_be :empty?
        end

        it 'has a :success attribute returning true' do
          expect(call_result.success).must_equal true
        end

        it 'also returns true from #success?' do
          expect(call_result).must_be :success?
        end

        it 'has a :failure attribute returning false' do
          expect(call_result.failure).must_equal false
        end

        it 'also returns false from #failure?' do
          expect(call_result).wont_be :failure?
        end

        describe 'when the current Member has' do
          let(:contribs) { call_result.contributions }
          let(:article_id) do
            artid_params = { title: 'A Title', author_name: 'N Author' }
            Prolog::Entities::ArticleIdentV.new artid_params
          end
          let(:identifier) { UUID.generate }
          let(:original_content) { 'original content' }
          let(:proposed_content) { 'replacement content' }
          let(:proposer) { 'Joe Bazooka' }

          describe 'no history of Contributions' do
            describe 'reports no Contributions have been' do
              it 'have been :accepted' do
                expect(contribs[:accepted]).must_be :empty?
              end

              it 'have been :proposed' do
                expect(contribs[:proposed]).must_be :empty?
              end

              it 'have been :rejected' do
                expect(contribs[:rejected]).must_be :empty?
              end
            end # describe 'reports no Contributions have been'
          end # describe 'no history of Contributions'

          describe 'Proposed Contributions not yet Responded to' do
            let(:contrib_params) do
              { article_id: article_id, identifier: identifier,
                original_content: original_content,
                proposed_content: proposed_content,
                proposer: proposer, justification: nil, proposed_at: nil }
            end
            let(:proposed_contributions) do
              [Prolog::Entities::Contribution::Proposed.new(contrib_params)]
            end
            let(:accepted_contributions) { [] }
            let(:rejected_contributions) { [] }

            it 'returns the correct values as :proposed Contributions' do
              expect(contribs[:proposed]).must_equal proposed_contributions
            end
          end # describe 'Proposed Contributions not yet Responded to'

          describe 'Accepted Contributions' do
            let(:proposed_contributions) { [] }
            let(:rejected_contributions) { [] }
            let(:accepted_contributions) do
              [Prolog::Entities::Contribution::Accepted.new(contrib_params)]
            end
            let(:contrib_params) do
              { article_id: article_id, identifier: identifier,
                proposal_id: proposal_id, response_text: response_text,
                updated_body: updated_body, responded_at: nil }
            end
            let(:proposal_id) { UUID.generate }
            let(:response_text) { 'Good catch.' }
            let(:updated_body) { 'This is a complete updated body.' }

            it 'returns the correct values as :accepted Contributions' do
              expect(contribs[:accepted]).must_equal accepted_contributions
            end
          end # describe 'Accepted Contributions'

          describe 'Rejected Contributions' do
            let(:accepted_contributions) { [] }
            let(:proposed_contributions) { [] }
            let(:rejected_contributions) do
              [Prolog::Entities::Contribution::Rejected.new(contrib_params)]
            end
            let(:contrib_params) do
              { article_id: article_id, identifier: identifier,
                proposal_id: proposal_id, response_text: response_text,
                responded_at: nil }
            end
            let(:proposal_id) { UUID.generate }
            let(:response_text) { 'Sorry, not even close.' }

            it 'returns the correct values as :rejected Contributions' do
              expect(contribs[:rejected]).must_equal rejected_contributions
            end
          end # describe 'Rejected Contributions'
        end # describe 'when the current Member has'
      end # describe 'returns a result object that'
    end # describe 'when the :authoriser indicates that a Member is logged in'
  end # describe 'has a .call method that'
end
