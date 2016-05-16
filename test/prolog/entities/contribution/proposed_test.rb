
# frozen_string_literal: true
require 'test_helper'

require 'matchers/raise_with_message'

require 'prolog/entities/contribution/proposed'

describe 'Prolog::Entities::Contribution::Proposed' do
  let(:described_class) { Prolog::Entities::Contribution::Proposed }
  let(:artid_class) { Prolog::Entities::ArticleIdentV }

  let(:all_params) do
    optionals = { justification: justification, proposed_at: proposed_at,
                  identifier: identifier }
    required_params.merge optionals
  end
  let(:required_params) do
    { article_id: article_id, endpoints: endpoints, proposer: proposer,
      proposed_content: proposed_content, justification: nil, proposed_at: nil,
      identifier: nil }
  end
  let(:article_id) { artid_class.new author_name: author_name, title: title }
  let(:author_name) { 'J Random Author' }
  let(:endpoints) { (0..-1) }
  let(:identifier) { '12345678-1234-5678-9012-123456789012' }
  let(:justification) { 'Just because.' }
  let(:proposed_at) { DateTime.parse '9 May 2016 12:34:56 SGT' }
  let(:proposed_content) { '<p>Complete replacement.</p>' }
  let(:proposer) { 'T Random Member' }
  let(:title) { 'This is a Title' }
  # Some CI servers are _really **slow.**_
  let(:ten_seconds) { 10.0 / (24 * 3600) }

  describe 'initialisation' do
    let(:endpoints) { -1 } # just to prove integer-to-range works
    let(:obj) { described_class.new required_params }

    it 'succeeds with all required and optional parameters' do
      expect(described_class.new all_params).must_be_instance_of described_class
    end

    describe 'supports explicit values for optional parameter named' do
      [:identifier, :justification, :proposed_at].each do |attrib|
        it ":#{attrib}" do
          required_params[attrib] = send(attrib)
          obj = described_class.new required_params
          expect(obj.send(attrib)).must_equal send(attrib)
        end
      end
    end # describe 'supports explicit values for optional parameter named'

    describe 'uses expected default attributes for' do
      it ':identifier' do
        expect(::UUID.validate obj.identifier).must_equal true
      end

      it ':justification' do
        expect(obj.justification).must_equal ''
      end

      it ':proposed_at' do
        expect(obj.proposed_at).must_be_close_to(DateTime.now, ten_seconds)
      end
    end # describe 'uses expected default attributes for'

    describe 'reports invalid attribute values for' do
      after do
        index = name.sub(/test_\d+_:/, '').to_sym
        required_params[index] = @bad_value
        expected = %([#{described_class}.new] "#{@bad_value}" (String) has ) +
                   %(invalid type for :#{index})
        expect do
          described_class.new required_params
        end.must_raise_with_message expected, Dry::Types::StructError
      end

      it ':identifier' do
        @bad_value = 'this is a bogus UUID'
      end

      it ':article_id' do
        @bad_value = 'this is a bad article ID'
      end
    end # describe 'reports invalid attribute values for'

    describe 'uses a default value when an invalid value is specified for' do
      after do
        index = name.sub(/test_\d+_/, '')
        required_params[index] = @bad_value
        obj = described_class.new required_params
        expect(obj.proposed_at).must_be_close_to(DateTime.now, ten_seconds)
      end

      it ':proposed_at' do
        @bad_value = 'this is an invalid DateTiem specification'
      end

      it ':endpoints' do
        @bad_value = 'this is a bad value'
      end
    end
  end # describe 'initialisation'

  it 'has a #type method that returne :edit' do
    expect(described_class.new(required_params).type).must_equal :edit
  end

  describe 'has a #to_h method that' do
    it 'returns a hash including a :type value of :edit' do
      obj = described_class.new required_params
      expect(obj.to_h[:type]).must_equal :edit
    end
  end # describe 'has a #to_h method that'
end
