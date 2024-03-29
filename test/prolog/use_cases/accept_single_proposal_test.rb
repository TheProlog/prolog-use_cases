# frozen_string_literal: true

# NOTE: The use case being tested here NO LONGER performs error-checking which
#       was specified in early drafts of the Wiki spec (prior to 30 Jun 2016).
#       Those have been repackaged into the new "Authorise Contribution
#       Response" use case, greatly simplifying the logic which would otherwise
#       be tested here.

require 'test_helper'
require 'matchers/raise_with_message_part'
require 'matchers/requires_initialize_parameter'

require 'prolog/entities/contribution/proposed'

require 'prolog/use_cases/accept_single_proposal'

describe 'Prolog::UseCases::AcceptSingleProposal' do
  let(:described_class) { Prolog::UseCases::AcceptSingleProposal }
  let(:init_params) { { article: article } }
  let(:article) { 'Dummy Article' }

  describe 'initialisation' do
    let(:params) { init_params }

    it 'requires an :article parameter' do
      expect(described_class).must_require_initialize_parameter params, :article
    end

    it 'succeeds when an :article parameter is specified' do
      expect(described_class.new params).must_be_instance_of described_class
    end
  end # describe 'initialisation'

  describe 'has a #call method that' do
    let(:obj) { described_class.new init_params }
    let(:article) do
      params = [author_name, proposed_body, title, article_id]
      Struct.new(:author_name, :body, :title, :article_id).new(*params).freeze
    end
    let(:article_id) { artid_class.new title: title, author_name: author_name }
    let(:artid_class) { Prolog::Entities::ArticleIdentV }
    let(:author_name) { 'J Random Author' }
    let(:body_content) { '<p>This is content.</p>' }
    let(:call_params) { { proposal: proposal, response_text: response_text } }
    let(:call_result) { obj.call call_params }
    let(:endpoints) { (3..18) } # 'T'..'.'
    let(:justification) { '' } # FIXME: Should default to '' -- Issue #80
    let(:original_content) { body_content[endpoints] }
    let(:proposal) { proposal_class.new proposal_params }
    let(:proposal_class) { Prolog::Entities::Contribution::Proposed }
    let(:proposal_params) do
      { article_id: article_id, original_content: original_content,
        proposed_content: proposed_content, proposer: proposer,
        justification: justification, proposed_at: proposed_at,
        identifier: identifier }
    end
    let(:proposed_at) { Time.now } # FIXME: Issue #80 - should be default
    let(:proposed_body) do
      outer_parts = body_content.split original_content
      format_str = %(<a id="contribution-#{identifier}-%s"></a>)
      mtp = [format(format_str, 'begin'), format(format_str, 'end')]
      outer_parts.join(mtp.join(original_content))
    end
    let(:proposed_content) { 'This is <em>updated</em> content.' }
    let(:proposer) { 'J Random Proposer' }
    let(:title) { 'A Title' }
    let(:identifier) { UUID.generate }
    let(:response_text) { '' } # FIXME: Issue #80 -- should be ''

    describe 'returns a Result object with' do
      it 'no :errors' do
        expect(call_result.errors).must_be :empty?
      end

      it 'an :original_content attribute that is not empty' do
        expect(call_result.original_content).wont_be :empty?
      end

      describe 'an accepted-proposal :entity that' do
        let(:entity) { call_result.entity }

        describe 'when an explicit author response is' do
          let(:expected_text) { '' }

          after do
            expect(entity.response_text).must_equal expected_text
          end

          describe 'provided' do
            let(:response_text) { 'Thank you for your contribution.' }
            let(:expected_text) { response_text }

            it 'the entity contains the provided message content' do
            end
          end # describe 'provided'

          describe 'not provided' do
            let(:response_text) { nil }
            let(:expected_text) { '' }

            it 'the entity contains an empty string for the response' do
            end
          end # describe 'not provided'
        end # describe 'when an explicit author response is'

        it 'contains the original proposal ID' do
          expect(entity.proposal_id).must_equal identifier
        end

        it 'contains a different value for the accepted-contribution ID' do
          expect(entity.identifier).wont_equal entity.proposal_id
        end
      end # describe 'an accepted-proposal :entity that'

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
  end # describe 'has a #call method that'
end
