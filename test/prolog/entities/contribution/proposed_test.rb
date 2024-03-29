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
    { article_id: article_id, original_content: original_content,
      proposed_content: proposed_content, proposer: proposer,
      # Defaults start here. FIXME: Issue #80
      justification: '', proposed_at: Time.now, identifier: ::UUID.generate }
  end
  let(:article_id) { artid_class.new author_name: author_name, title: title }
  let(:author_name) { 'J Random Author' }
  let(:identifier) { '12345678-1234-5678-9012-123456789012' }
  let(:justification) { '' }
  let(:original_content) { '<p>This is <em>original</em> content.</p>' }
  let(:proposed_at) { Time.parse '9 May 2016 12:34:56 SGT' }
  let(:proposed_content) { '<p>Complete replacement.</p>' }
  let(:proposer) { 'T Random Member' }
  let(:title) { 'This is a Title' }

  describe 'initialisation' do
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
        # Some CI servers are *really slow.*
        TEN_SECONDS = 10

        expect(obj.proposed_at).must_be_close_to(Time.now, TEN_SECONDS)
      end
    end # describe 'uses expected default attributes for'

    describe 'reports invalid attribute values for' do
      after do
        index = name.sub(/test_\d+_:/, '').to_sym
        # FIXME: Issue #80.
        all_params[index] = @bad_value
        expect { described_class.new all_params }.must_raise @error_class
      end

      it ':identifier' do
        @bad_value = 'this is a bogus UUID'
        @error_class = Dry::Struct::Error
      end

      it ':article_id' do
        @bad_value = 'this is a bad article ID'
        @error_class = TypeError
      end
    end # describe 'reports invalid attribute values for'

    # FIXME: Issue #80
    # describe 'uses a default value when an invalid value is specified for' do
    #   after do
    #     index = name.sub(/test_\d+_/, '')
    #     required_params[index] = @bad_value
    #     obj = described_class.new required_params
    #     expect(obj.proposed_at).must_be_close_to(Time.now, ten_seconds)
    #   end
    #
    #   it ':proposed_at' do
    #     @bad_value = 'this is an invalid DateTiem specification'
    #   end
    # end
  end # describe 'initialisation'

  it 'has a #type method that returne :edit' do
    expect(described_class.new(required_params).type).must_equal :edit
  end

  describe 'delegates to the :article_id attribute methods for' do
    let(:obj) { described_class.new required_params }

    it ':author_name' do
      expect(obj.author_name).must_equal author_name
    end

    it ':title' do
      expect(obj.title).must_equal title
    end
  end # describe 'delegates to the :article_id attribute methods for'

  describe 'has a #to_h method that' do
    it 'returns a hash including a :type value of :edit' do
      obj = described_class.new required_params
      expect(obj.to_h[:type]).must_equal :edit
    end
  end # describe 'has a #to_h method that'
end
