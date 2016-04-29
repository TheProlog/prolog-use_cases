
require 'test_helper'

require 'prolog/use_cases/validate_selection'

describe 'Prolog::UseCases::ValidateSelection' do
  let(:described_class) { Prolog::UseCases::ValidateSelection }
  let(:params) do
    { article: article, replacement_content: replacement_content,
      endpoints: endpoints, authoriser: authoriser }
  end
  let(:article) { Struct.new(:body).new body_content }

  describe 'initialisation requires parameters for' do
    let(:authoriser) { Object.new }
    let(:body_content) { 'Body Content is Here.' }
    let(:endpoints) { (7..11) }
    let(:replacement_content) { "replacement content in #{__FILE__}" }

    [:article, :endpoints].each do |attrib|
      it attrib.to_s do
        params.delete attrib
        obj = described_class.new params
        expect(obj).wont_be :valid?
      end
    end
  end # describe 'initialisation requires parameters for'

  describe 'has a #call method that' do
    describe 'when initialised with parameters that' do
      let(:authoriser) { Struct.new(:guest?).new is_guest }
      let(:body_content) { '<p>This is <em>example</em> content.</p>' }
      let(:endpoints) { (ep_begin...ep_end) }
      let(:ep_begin) { body_content.index '<em>example' }
      let(:ep_end) { body_content.index ' content' }
      let(:is_guest) { false }
      let(:replacement_content) { 'basic' }
      let(:call_params) do
        { replacement_content: replacement_content, endpoints: endpoints }
      end
      let(:init_params) do
        { article: article, authoriser: authoriser }
      end
      let(:obj) { described_class.new init_params }

      # "Valid and correct" is *not* redundant. Parameters can be valid while
      # not being correct, e.g., because they overlap an existing marker tag
      # pair.
      describe 'are completely valid and correct' do
        it 'returns true' do
          expect(obj.call call_params).must_equal true
        end

        it 'has no errors' do
          obj.call call_params
          expect(obj.errors).must_be :empty?
        end
      end # describe 'are completely valid and correct'

      describe 'are invalid due to' do
        describe 'no logged-in Member' do
          let(:is_guest) { true }

          it 'returns false' do
            expect(obj.call call_params).must_equal false
          end

          it 'reports no current logged-in user as an error' do
            obj.call call_params
            expected = { current_user: 'not logged in' }
            expect(obj.errors.to_h).must_equal expected
          end
        end # describe 'no logged-in Member'

        describe 'missing' do
          let(:call_result) { obj.call call_params }

          describe 'initialisation attributes for' do
            [:article, :authoriser].each do |attrib|
              describe "a missing :#{attrib} attribute" do
                it 'returns failure' do
                  init_params.delete attrib
                  expect(call_result).must_equal false
                  expect(obj.call call_params).must_equal false
                end

                it "reports a missing :#{attrib} attribute as an error" do
                  init_params.delete attrib
                  obj.call call_params
                  expect(obj.errors[attrib]).must_equal [' is required.']
                end
              end # describe "a missing :#{attrib} attribute"
            end
          end # describe 'initialisation attributes for'

          describe '#call attributes for' do
            [:endpoints, :replacement_content].each do |attrib|
              it 'returns failure' do
                call_params.delete attrib
                expect(obj.call call_params).must_equal false
              end

              it "reports a missing :#{attrib} attribute as an error" do
                call_params.delete attrib
                obj.call call_params
                expect(obj.errors[attrib]).must_include ' is required.'
              end
            end
          end # describe '#call attributes for'
        end # describe 'missing'
      end # describe 'are invalid due to'
    end # describe 'when initialised with parameters that'
  end # describe 'has a #call method that'
end
