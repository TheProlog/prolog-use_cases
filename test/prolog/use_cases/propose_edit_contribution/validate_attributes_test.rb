# frozen_string_literal: true

require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution/validate_attributes'

describe 'Prolog::UseCases::ProposeEditContribution::ValidateAttributes' do
  let(:described_class) do
    Prolog::UseCases::ProposeEditContribution::ValidateAttributes
  end
  let(:required_attributes) do
    params = { article: article, endpoints: endpoints, proposer: proposer,
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
  let(:endpoints) { (0..-1) }
  let(:proposer) { 'P Random Proposer' }
  let(:proposed_content) { '<p>Entire replacement.</p>' }
  let(:justification) { 'Just because.' }
  let(:proposed_at) { Time.parse '13 May 2016 12:34:56 SGT' }

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

        describe 'including instances where' do
          describe 'the proposed content is' do
            describe 'empty' do
              let(:proposed_content) { '' }

              it 'reports being valid' do
                expect(obj).must_be :valid?
              end
            end # describe 'empty'

            describe 'blank' do
              let(:proposed_content) { ' ' }

              it 'reports being valid' do
                expect(obj).must_be :valid?
              end
            end # describe 'blank'
          end # describe 'the proposed content is'
        end # describe 'including instances where'
      end # describe 'valid required parameters'

      describe 'all supported valid parameters' do
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
        let(:proposer) { 'Guest User' }

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

      # NOTE: We can accept empty replacement text, but *not* an empty selection
      # within the article body. If we use the endpoints to extract a selection
      # from the article body and it hands us back an empty string, that's a
      # Problem.
      describe 'endpoints specifying an empty string within article body' do
        let(:endpoints) { (427..-1) }

        it 'reports being invalid' do
          expect(obj).wont_be :valid?
        end

        it 'reports a single error' do
          expect(obj.errors.count).must_equal 1
        end

        describe 'reports the correct error data, including the' do
          let(:error) do
            JSON.parse obj.errors[:endpoints], symbolize_names: true
          end

          it 'reason for failure' do
            expect(error[:failure]).must_equal 'invalid endpoints'
          end

          it 'YAML-encoded article ID' do
            actual = error[:article_id]
            expected = YAML.dump attributes.article_id
            expect(actual).must_equal expected
          end
        end # describe 'reports the correct error data, including the'
      end # describe 'endpoints specifying an empty string within article body'
    end # describe 'parameters which are invalid due to'
  end # describe 'when calling the #call method with'
end
