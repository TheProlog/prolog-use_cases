
require 'test_helper'

require 'prolog/use_cases/validate_selection/form_object'

describe 'Prolog::UseCases::ValidateSelection::FormObject' do
  let(:described_class) { Prolog::UseCases::ValidateSelection::FormObject }
  let(:article) do
    Struct.new(:body).new '<p>This is dummy content.</p>'
  end
  let(:begin_endpoint) { article.body.index 'dummy' }
  let(:end_endpoint) { article.body.index ' content.' }
  let(:endpoints) { (begin_endpoint..end_endpoint) }
  let(:params) { { article: article, endpoints: endpoints } }
  let(:obj) { described_class.new params }

  describe 'initialisation' do
    describe 'supports an attribute for' do
      after do
        expect(obj.send(@index)).must_equal params[@index]
      end

      [:article, :endpoints].each do |attrib|
        it "#{attrib}" do
          @index = attrib
        end
      end
    end # describe 'supports an attribute for'

    describe 'invalidates the instance when' do
      after do
        expect(obj).wont_be :valid?
      end

      [:article, :endpoints].each do |attrib|
        it "the #{attrib} attribute is missing" do
          params.delete attrib
        end
      end

      it 'the ending endpoint exceeds the allowable range' do
        params[:endpoints] = (begin_endpoint..article.body.length + 2)
      end
    end # describe 'invalidates the instance when'
  end # describe 'initialisation'
end
