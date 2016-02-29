
require 'test_helper'

require 'prolog/services/content_selection/form_object'

describe 'Prolog::Services::ContentSelection::FormObject' do
  let(:described_class) { Prolog::Services::ContentSelection::FormObject }

  let(:article) { Prolog::Core::Article.new body: body, author_name: 'John Q' }
  let(:begin_endpoint) { 0 }
  let(:body) do
    '<p>This is <em>emphasised</em> body content.</p><p>Deal with it.</p>'
  end
  let(:endpoints) { (start_endpoint..end_endpoint) }
  let(:end_endpoint) { 7 }
  let(:last_contribution_id) { 42 }
  let(:start_endpoint) { 0 }
  let(:obj) { described_class.new params }
  let(:params) do
    { article: article, endpoints: endpoints,
      last_contribution_id: last_contribution_id }
  end

  describe 'when instantiated with complete and valid parameters, it' do
    before { obj.valid? }

    it 'is valid' do
      expect(obj).must_be :valid?
    end

    it 'has no errors reported' do
      expect(obj.errors).must_be :empty?
    end
  end # describe 'when instantiated with complete and valid parameters, it'

  describe 'when instantiated without parameters, it is invalid, reporting' do
    let(:obj) { described_class.new }

    before { obj.valid? }

    it 'a missing :last_contribution_id' do
      expect(obj.errors[:last_contribution_id]).must_equal %w(missing)
    end

    it 'an invalid :article' do
      expect(obj.errors[:article]).must_equal %w(invalid)
    end

    it 'an invalid :endpoints range' do
      expect(obj.errors[:endpoints]).must_equal %w(invalid)
    end
  end # describe 'when instantiated without parameters, it is invalid, ...'

  describe 'when instantiated using enspoints that are' do
    it 'string representations of integers, all is well' do
      params[:endpoints] = '8'..'30'
      expect(obj).must_be :valid?
    end

    describe 'a single integer-coercible value rather than a range' do
      let(:endpoints) { '30' }

      it 'the object is valid' do
        expect(obj).must_be :valid?
      end

      it 'the endpoints range from zero up to the (integral) value' do
        expect(obj.endpoints).must_equal 0..endpoints.to_i
      end
    end # describe 'a single integer-coercible value rather than a range'

    describe 'an invalid value, the resulting' do
      let(:endpoints) { 'garbage' }

      before { obj.valid? }

      it 'object is not valid' do
        expect(obj).wont_be :valid?
      end

      it 'endpoints will be (-1..-1)' do
        expected = (-1..-1)
        expect(obj.endpoints).must_equal expected
      end
    end # describe 'an invalid value, the resulting'
  end # describe 'when instantiated using enspoints that are'

  describe 'has a #selected_markup method that' do
    it 'initially returns an empty string' do
      expect(described_class.new.selected_markup).must_equal ''
    end

    # Note that markup is not automatically cleaned up/tags closed; caller is
    # responsible for that!
    it 'when called on a valid object, returns body markup within endpoints' do
      expect(obj.selected_markup).must_equal '<p>This '
    end
  end # describe 'has a #selected_markup method that'
end
