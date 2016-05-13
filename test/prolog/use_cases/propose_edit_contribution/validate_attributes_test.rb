
# frozen_string_literal: true
require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution/validate_attributes'

describe 'Prolog::UseCases::ProposeEditContribution::ValidateAttributes' do
  let(:described_class) do
    Prolog::UseCases::ProposeEditContribution::ValidateAttributes
  end
  let(:required_attributes) do
    params = { article: article, endpoints: endpoints, proposed_by: proposed_by,
               proposed_content: proposed_content }
    OpenStruct.new(params).freeze
  end
  let(:optional_attributes) do
    params = { justification: justification, proposed_at: proposed_at }
    OpenStruct.new(params).freeze
  end
  let(:attributes) do
    params = required_attributes.to_h.merge optional_attributes.to_h
    attribs = { author_name: article.author_name, title: article.title }
    params[:article_id] = attribs.freeze
    OpenStruct.new(params).freeze
  end

  let(:article) do
    Struct.new(:author_name, :body, :title).new author_name, body, title
  end
  let(:author_name) { 'J Random Author' }
  let(:body) { 'Article Body' }
  let(:title) { 'Article Title' }
  let(:endpoints) { Object.new }
  let(:proposed_by) { 'P Random Proposer' }
  let(:proposed_content) { '<p>Entire replacement.</p>' }
  let(:justification) { 'Just because.' }
  let(:proposed_at) { DateTime.parse '13 May 2016 12:34:56 SGT' }

  describe 'when calling the #call method with' do
    describe 'a complete set of' do
      describe 'valid required parameters' do
        let(:obj) { described_class.new.call required_attributes }

        it 'reports being valid' do
          expect(obj).must_be :valid?
        end

        it 'reports no errors' do
          expect(obj.errors).must_be :empty?
        end
      end # describe 'valid required parameters'

      describe 'all supported valid  parameters' do
        let(:obj) { described_class.new.call attributes }

        it 'reports being valid' do
          expect(obj).must_be :valid?
        end

        it 'reports no errors' do
          expect(obj.errors).must_be :empty?
        end
      end # describe 'all supported valid parameters'
    end # describe 'a complete set of'

    describe 'parameters which are invalid due to' do
      let(:obj) { described_class.new.call(attributes) }

      describe 'the proposer not being a logged-in member' do
        let(:proposed_by) { 'Guest User' }

        it 'reports being invalid' do
          expect(obj).wont_be :valid?
        end

        it 'reports a single error' do
          expect(obj.errors.count).must_equal 1
        end

        describe 'reports the correct error data, including the' do
          let(:error) do
            JSON.parse obj.errors[:authoriser], symbolize_names: true
          end

          it 'reason for failure' do
            expect(error[:failure]).must_equal 'not logged in'
          end

          it 'YAML-encoded article ID' do
            actual = error[:article_id]
            expected = YAML.dump attributes.article_id
            expect(actual).must_equal expected
          end
        end # describe 'reports the correct error data, including the'
      end # describe 'the proposer not being a logged-in member'

      describe 'the proposed content is' do
        # NOTE: We believe that real-world use will eventually show that
        # requiring proposed content not to be an empty string will be
        # desirable; members will (or can easily be encouraged to) select the
        # words before and/or after content that they wish to delete. However,
        # that will have to wait for The Glorious Future.
        let(:error) do
          JSON.parse obj.errors[:proposed_content], symbolize_names: true
        end

        describe 'missing' do
          let(:proposed_content) { nil }

          it 'reports being invalid' do
            expect(obj).wont_be :valid?
          end
        end # describe 'missing'
      end # describe 'the proposed content is'
    end # describe 'parameters which are invalid due to'
  end # describe 'when calling the #call method with'
end
