
require 'test_helper'

require 'prolog/services/content_selection'

def anchor_tag_pair_for(which_end, last_contribution_id)
  format '<a id="selection-%d-%s"></a>', last_contribution_id, which_end
end

describe 'Prolog::Services::ContentSelection' do
  let(:described_class) { Prolog::Services::ContentSelection }
  let(:obj) { described_class.new }

  it 'can be instantiated without parameters' do
    expect { described_class.new }.must_be_silent
  end

  describe 'has an attribute named' do
    describe ':selected_markup' do
      it 'that is initially an empty string' do
        expect(obj.selected_markup).must_equal ''
      end

      it 'that is not writeable' do
        expect(obj).wont_respond_to :selected_markup=
      end
    end # describe ':selected_markup'

    describe ':last_contribution_id' do
      it 'that has an initial value of 0' do
        expect(obj.last_contribution_id).must_be :zero?
      end

      it 'that is not writeable' do
        expect(obj).wont_respond_to :last_contribution_id=
      end
    end # describe ':contribution_counter'

    describe ':errors' do
      it 'that is initially empty' do
        expect(obj.errors).must_be :empty?
      end
    end # describe ':errors'
  end # describe 'has an attribute named'

  it 'has a #call method' do
    expect(obj).must_respond_to :call
  end

  describe 'has a #call method that' do
    let(:article) do
      Prolog::Core::Article.new body: body, author_name: author_name
    end
    let(:author_name) { 'John Q Public' }
    let(:body) do
      '<p>This is <em>emphasised</em> body content.</p><p>Deal with it.</p>'
    end
    let(:endpoints) { (start_endpoint..end_endpoint) }
    let(:end_endpoint) { 35 }
    let(:last_contribution_id) { 42 }
    let(:start_endpoint) { 11 }
    let(:call_params) do
      { article: article, endpoints: endpoints,
        last_contribution_id: last_contribution_id }
    end
    let(:call_result) { obj.call call_params }

    before { obj.call call_params }

    describe 'when called with a complete set of valid parameters' do
      it 'makes a copy of the selected markup available as :selected_markup' do
        expect(obj.selected_markup).must_equal body[endpoints]
      end

      it 'increments the :last_contribution_id attribute' do
        expect(obj.last_contribution_id).must_equal last_contribution_id + 1
      end

      describe 'sets the :updated_body attribute, such that' do
        it 'the content preceding the selected markup is copied intact' do
          before_selection = 0...start_endpoint
          expected = article.body[before_selection]
          expect(obj.updated_body[before_selection]).must_equal expected
        end

        it 'an opening ID-anchor tag pair is directly after initial content' do
          expected_markup = anchor_tag_pair_for :begin, last_contribution_id
          range_end = start_endpoint + expected_markup.length
          parts_range = start_endpoint...range_end
          expect(obj.updated_body[parts_range]).must_equal expected_markup
        end

        it 'the selected markup immediately follows that ID-anchor tag pair' do
          target = anchor_tag_pair_for(:begin, last_contribution_id) +
                   obj.selected_markup
          expect(obj.updated_body.scan(target).count).must_equal 1
        end

        it 'a closing ID-anchor tag pair is directly after selected markup' do
          target = obj.selected_markup +
                   anchor_tag_pair_for(:end, last_contribution_id)
          expect(obj.updated_body.scan(target).count).must_equal 1
        end

        it 'the content following the selected markup is copied intact' do
          target = obj.selected_markup +
                   anchor_tag_pair_for(:end, last_contribution_id)
          index = obj.updated_body.index(target) + target.length
          expected = article.body[end_endpoint..-1]
          expect(obj.updated_body[index..-1]).must_equal expected
        end
      end # describe 'sets the :updated_body attribute, such that'
    end # describe 'when called with a complete set of valid parameters'
  end # describe 'has a #call method that'
end
