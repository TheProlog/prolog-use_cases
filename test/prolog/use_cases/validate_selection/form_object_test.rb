
require 'test_helper'

require 'prolog/use_cases/validate_selection/form_object'

describe 'Prolog::UseCases::ValidateSelection::FormObject' do
  let(:described_class) { Prolog::UseCases::ValidateSelection::FormObject }
  let(:article) do
    Struct.new(:body).new '<p>This is dummy content.</p>'
  end
  let(:authoriser) { Struct.new(:guest?).new is_guest }
  let(:begin_endpoint) { article.body.index 'dummy' }
  let(:end_endpoint) { article.body.index ' content.' }
  let(:endpoints) { (begin_endpoint..end_endpoint) }
  let(:is_guest) { false }
  let(:params) do
    { article: article, authoriser: authoriser, endpoints: endpoints,
      replacement_content: replacement_content }
  end
  let(:replacement_content) { '<em>sample</em>' }
  let(:obj) { described_class.new params }

  describe 'initialisation' do
    describe 'supports an attribute for' do
      after do
        expect(obj.send(@index)).must_equal params[@index]
      end

      [:article, :authoriser, :endpoints, :replacement_content].each do |attrib|
        it attrib.to_s do
          @index = attrib
        end
      end
    end # describe 'supports an attribute for'

    describe 'invalidates the instance when' do
      after do
        expect(obj).wont_be :valid?
      end

      [:article, :authoriser, :endpoints].each do |attrib|
        it "the #{attrib} attribute is missing" do
          params.delete attrib
        end
      end

      it 'the authoriser object reports a guest user' do
        params[:authoriser] = Struct.new(:guest?).new true
      end

      it 'the ending endpoint exceeds the allowable range' do
        params[:endpoints] = (begin_endpoint..article.body.length + 2)
      end

      it 'the replacement content includes bad HTML' do
        params[:replacement_content] = '<em>invalid</i>'
      end
    end # describe 'invalidates the instance when'
  end # describe 'initialisation'
end
