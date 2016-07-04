# frozen_string_literal: true

require 'test_helper'

require 'matchers/raise_with_message_part'

require 'prolog/entities/contribution/accepted'

describe 'Prolog::Entities::Contribution::Accepted' do
  let(:described_class) { Prolog::Entities::Contribution::Accepted }
  let(:artid_class) { Prolog::Entities::ArticleIdentV }

  let(:all_params) do
    optionals = { identifier: identifier, responded_at: responded_at,
                  response_text: response_text }
    required_params.merge optionals
  end
  let(:article_id) { artid_class.new author_name: author_name, title: title }
  let(:author_name) { 'J Random Author' }
  let(:identifier) { '12345678-1234-5678-9012-123456789012' }
  let(:obj) { described_class.new required_params }
  let(:proposal_id) { '87654321-9876-5432-1098-987654321098' }
  let(:required_params) do
    { article_id: article_id, proposal_id: proposal_id,
      updated_body: updated_body, identifier: nil, responded_at: nil,
      response_text: nil }
  end
  let(:responded_at) { DateTime.parse '2 Jun 2016 01:23:45 SGT' }
  let(:response_text) { 'Roger dodger' }
  let(:title) { 'This is a Title' }
  let(:updated_body) { 'Update your body with exercise.' }

  describe 'initialisation' do
    let(:obj) { described_class.new required_params }

    describe 'succeeds with' do
      after do
        expect(described_class.new @params).must_be_instance_of described_class
      end

      it 'all required parameters' do
        @params = required_params
      end

      it 'all required and optional parameters' do
        @params = all_params
      end
    end # describe 'succeeds with'

    it 'raises an error when an empty string is supplied as :updated_body' do
      required_params[:updated_body] = ''
      expected = 'invalid type for :updated_body'
      expect do
        described_class.new required_params
      end.must_raise_with_message_part expected, Dry::Types::StructError
    end
  end # describe 'initialisation'

  it 'has a #type method that returne :edit' do
    expect(described_class.new(required_params).type).must_equal :edit
  end

  describe 'delegates to the :article_id attribute methods for' do
    it ':author_name' do
      expect(obj.author_name).must_equal author_name
    end

    it ':title' do
      expect(obj.title).must_equal title
    end
  end # describe 'delegates to the :article_id attribute methods for'

  describe 'has a #to_h method that' do
    it 'returns a hash including a :type value of :edit' do
      expect(obj.to_h[:type]).must_equal :edit
    end
  end # describe 'has a #to_h method that'
end
