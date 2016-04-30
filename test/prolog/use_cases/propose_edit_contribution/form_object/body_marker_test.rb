# frozen_string_literal: true

require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution/form_object/body_marker'

describe 'Prolog::UseCases::ProposeEditContribution::FormObject::BodyMarker' do
  let(:described_class) do
    Prolog::UseCases::ProposeEditContribution::FormObject::BodyMarker
  end
  let(:body_content) { '<p>This is some <em>example</em> content.' }
  let(:body) { body_content.dup }
  let(:ending_ep) { body.index ' content' }
  let(:endpoints) { (starting_ep..ending_ep) }
  let(:id_number) { 42 }
  let(:params) { { body: body, endpoints: endpoints, id_number: id_number } }
  let(:starting_ep) { body.index '<em>' }

  describe 'initialisation requires named parameter values for' do
    after do
      params.delete @param
      error = expect { described_class.new params }.must_raise ArgumentError
      expect(error.message).must_equal "missing keyword: #{@param}"
    end

    [:body, :endpoints, :id_number].each do |param|
      it param.to_s do
        @param = param
      end
    end
  end # describe 'initialisation requires named parameter values for'

  describe 'has a #to_s method that' do
    let(:obj) { described_class.new params }
    let(:start_marker) { %(<a id="contribution-#{id_number}-begin></a>") }
    let(:end_marker) { %(<a id="contribution-#{id_number}-end></a>") }
    let(:end_fragment_offset) do
      ending_ep + start_marker.length + end_marker.length
    end
    let(:end_fragment) { obj.to_s[end_fragment_offset..-1] }

    before { @actual = obj.to_s }

    describe 'renders the markup' do
      it 'before the starting endpoint without change' do
        expected = body_content[0...starting_ep]
        expect(@actual[0...starting_ep]).must_equal expected
      end

      it 'originally occurring after the ending endpoint without change' do
        expect(end_fragment).must_equal body_content[ending_ep..-1]
      end

      it 'originally between the endpoints, between the new markers' do
        new_start = starting_ep + start_marker.length
        new_end = ending_ep + start_marker.length
        expected = body_content[starting_ep...ending_ep]
        expect(@actual[new_start...new_end]).must_equal expected
      end
    end # describe 'renders the markup'
  end # describe 'has a #to_s method that'
end
