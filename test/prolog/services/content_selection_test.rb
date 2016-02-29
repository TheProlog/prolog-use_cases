
require 'test_helper'

require 'prolog/services/content_selection'

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
    let(:params) do
      {}
    end
  end # describe 'has a #call method that'
end
