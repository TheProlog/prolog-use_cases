
require 'test_helper'

require 'prolog/use_cases/validate_selection'

describe 'Prolog::UseCases::ValidateSelection' do
  let(:described_class) { Prolog::UseCases::ValidateSelection }
  let(:params) do
    { article: article, replacement_content: replacement_content,
      endpoints: endpoints, authoriser: authoriser, ui_gateway: ui_gateway }
  end
  let(:article) { Struct.new(:body).new body_content }
  let(:error_container) do
    Class.new do
      attr_reader :errors

      def initialize
        @errors = {}
        self
      end

      def add(key, values)
        data = errors[key] || []
        errors[key] = data.merge(values).uniq
      end
    end.new
  end

  describe 'initialisation requires parameters for' do
    let(:authoriser) { Object.new }
    let(:body_content) { 'Body Content is Here.' }
    let(:endpoints) { (7..11) }
    let(:replacement_content) { "replacement content in #{__FILE__}" }
    let(:ui_gateway) { Object.new }

    [:article, :endpoints].each do |attrib|
      it "#{attrib}" do
        params.delete attrib
        obj = described_class.new params
        expect(obj).wont_be :valid?
      end
    end
  end # describe 'initialisation requires parameters for'

  describe 'has a #call method that' do
    describe 'when initialised with parameters that' do
      # "Valid and correct" is *not* redundant. Parameters can be valid while
      # not being correct, e.g., because they overlap an existing marker tag
      # pair.
      describe 'are completely valid and correct' do
        let(:authoriser) { Struct.new(:guest?).new false }
        let(:body_content) { '<p>This is <em>example</em> content.</p>' }
        let(:endpoints) { (ep_begin...ep_end) }
        let(:ep_begin) { body_content.index '<em>example' }
        let(:ep_end) { body_content.index ' content' }
        let(:replacement_content) { 'basic' }
        let(:ui_gateway) do
          Class.new do
            attr_reader :errors

            def initialize(error_container)
              @errors = error_container
              self
            end
          end.new(error_container)
        end
        let(:call_params) do
          { replacement_content: replacement_content, endpoints: endpoints }
        end
        let(:init_params) do
          { article: article, authoriser: authoriser, ui_gateway: ui_gateway }
        end
        let(:obj) { described_class.new init_params }

        it 'returns true' do
          expect(obj.call call_params).must_equal true
        end

        it 'has no errors' do
          obj.call call_params
          expect(obj.errors).must_be :empty?
        end
      end # describe 'are completely valid and correct'
    end # describe 'when initialised with parameters that'
  end # describe 'has a #call method that'
end
