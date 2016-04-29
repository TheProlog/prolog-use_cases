# frozen_string_literal: true

require 'test_helper'

req_filename = 'prolog/use_cases/propose_edit_contribution/form_object/' \
  'proposed_content_validator'
require req_filename

described_class = Prolog::UseCases::ProposeEditContribution::FormObject
                  .const_get :ProposedContentValidator

describe described_class.name do
  let(:article_id) { 'Article ID' }
  let(:obj) do
    described_class.new article_id: article_id,
                        proposed_content: proposed_content
  end

  describe 'when :proposed_content is' do
    describe 'non-empty, non-blank, non-nil content' do
      let(:proposed_content) { 'This should be valid.' }

      it 'is valid' do
        expect(obj).must_be :valid?
      end

      describe 'produces a JSON-encoded payload which has' do
        let(:payload) { JSON.parse obj.payload }

        it 'the originally-specified article ID' do
          expect(payload['article_id']).must_equal article_id
        end

        it 'a "failure" message indicating the content should be valid' do
          expected = 'should be valid proposed content'
          expect(payload['failure']).must_equal expected
        end
      end # describe 'produces a JSON-encoded payload which has'
    end #   describe 'non-empty, non-blank, non-nil content'

    describe 'missing' do
      let(:proposed_content) { nil }

      it 'is not valid' do
        expect(obj).wont_be :valid?
      end

      describe 'produces a JSON-encoded payload which has' do
        let(:payload) { JSON.parse obj.payload }

        it 'the originally-specified article ID' do
          expect(payload['article_id']).must_equal article_id
        end

        it 'a "failure" message indicating the content is missing' do
          expected = 'missing proposed content'
          expect(payload['failure']).must_equal expected
        end
      end # describe 'produces a JSON-encoded payload which has'
    end # describe 'missing'

    describe 'empty' do
      let(:proposed_content) { '' }

      it 'is not valid' do
        expect(obj).wont_be :valid?
      end

      describe 'produces a JSON-encoded payload which has' do
        let(:payload) { JSON.parse obj.payload }

        it 'the originally-specified article ID' do
          expect(payload['article_id']).must_equal article_id
        end

        it 'a "failure" message indicating the content is empty' do
          expected = 'empty proposed content'
          expect(payload['failure']).must_equal expected
        end
      end # describe 'produces a JSON-encoded payload which has'
    end # describe 'empty'

    describe 'blank' do
      let(:proposed_content) { '     ' }

      it 'is not valid' do
        expect(obj).wont_be :valid?
      end

      describe 'produces a JSON-encoded payload which has' do
        let(:payload) { JSON.parse obj.payload }

        it 'the originally-specified article ID' do
          expect(payload['article_id']).must_equal article_id
        end

        it 'a "failure" message indicating the content is blank' do
          expected = 'blank proposed content'
          expect(payload['failure']).must_equal expected
        end
      end # describe 'produces a JSON-encoded payload which has'
    end # describe 'empty'
  end # describe 'when :proposed_content is'
end
