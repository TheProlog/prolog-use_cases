
require 'test_helper'

require 'ffaker'

require 'prolog/use_cases/publish_new_article'

describe 'Prolog::UseCases::PublishNewArticle' do
  let(:described_class) { Prolog::UseCases::PublishNewArticle }
  let(:authoriser) { guest_authoriser }
  let(:guest_authoriser) do
    Struct.new(:guest?, :current_user).new true, 'Guest User'
  end
  let(:init_params) { { repository: repository, authoriser: authoriser } }
  let(:obj) { described_class.new init_params }
  let(:repository) { Object.new }

  describe 'must be initialised with a named parameter value for' do
    after do
      init_params.delete @param
      error = expect do
        described_class.new init_params
      end.must_raise ArgumentError
      expect(error.message).must_equal "missing keyword: #{@param}"
    end

    it ':repository' do
      @param = :repository
    end

    it ':authoriser' do
      @param = :authoriser
    end
  end # describe 'must be initialised with a named parameter value for'

  describe 'has a #call instance method that' do
    it 'takes one parameter, marked as a "variable number of arguments"' do
      method = obj.method :call
      expect(method.arity).must_equal(-1)
    end

    describe 'when called while a user is not logged in' do
      it 'returns :precondition_failed' do
        expect(obj.call).must_equal :precondition_failed
      end

      it 'sets the appropriate entry in #notifications' do
        expected = { current_user: [:not_logged_in] }
        obj.call
        expect(obj.notifications).must_equal expected
      end
    end # describe 'when called while a user is not logged in'

    describe 'when called with a complete set of field values and' do
      let(:call_params) do
        { author_name: author_name, title: title, body: body,
          image_url: image_url }
      end
      let(:author_name) { 'Jane Doe' }
      let(:body) { FFaker::Lorem.paragraphs(rand(3..6)).join "\n" }
      let(:image_url) { "http://example.com/#{FFaker::Internet.slug}" }
      let(:title) { FFaker::HipsterIpsum.phrase }

      describe 'the current user is' do
        describe 'not the identified author' do
          let(:authoriser) do
            Struct.new(:guest?, :current_user).new false, 'Joe Blow'
          end
          let(:return_value) { obj.call call_params }

          it 'returns :precondition_failed' do
            expect(return_value).must_equal :precondition_failed
          end

          it 'reports that the :author_name does not match the current user' do
            expected = { author_name: ['not current user'] }
            _ = return_value
            expect(obj.notifications).must_equal expected
          end
        end # describe 'not the identified author'
      end # describe 'the current user is'
    end # describe 'when called with a complete set of field values and'
  end # describe 'has a #call instance method that'
end
