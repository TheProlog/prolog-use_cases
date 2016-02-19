
require 'test_helper'

require 'ffaker'

require 'prolog/core'

require 'prolog/use_cases/register_new_member'

describe 'Prolog::UseCases::RegisterNewMember' do
  let(:described_class) { Prolog::UseCases::RegisterNewMember }
  let(:authoriser) { Object.new }
  let(:init_params) { { repository: repository, authoriser: authoriser } }
  let(:obj) { described_class.new init_params }
  let(:repository) do
    Class.new do
      def initialize(user_present, save_succeeds)
        @user_present = user_present
        @save_succeeds = save_succeeds
        self
      end

      def query_user_by_name(_name)
        return :not_present unless @user_present
        :user_instance_should_be_here
      end

      def save_user(entity)
        return :save_failed unless @save_succeeds
        entity
      end
    end.new(user_present, save_succeeds)
  end
  let(:save_succeeds) { true }
  let(:user_class) { Prolog::Core::User }
  let(:user_present) { false }

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
    let(:params) do
      { name: user_name, email: email, profile: profile, password: password,
        password_confirmation: password_confirmation }
    end
    let(:email) { FFaker::Internet.safe_email name }
    let(:password) { FFaker::Internet.password }
    let(:password_confirmation) { password }
    let(:profile) { FFaker::HipsterIpsum.phrase }
    let(:user_name) { FFaker::Name.name }

    it 'takes one parameter, marked as a "variable number of arguments"' do
      method = obj.method :call
      expect(method.arity).must_equal(-1)
    end

    describe 'when called while a user is' do
      describe 'logged in' do
        let(:authoriser) { Struct.new(:guest?).new false }

        it 'returns :precondition_failed' do
          expect(obj.call).must_equal :precondition_failed
        end

        it 'stores a :failure notification indicating :already_logged_in' do
          obj.call
          expect(obj.notifications[:failure]).must_equal [:already_logged_in]
        end
      end # describe 'logged in'

      describe 'not logged in' do
        let(:authoriser) { Struct.new(:guest?).new true }

        it 'does not return nil' do
          expect(obj.call params).wont_be :nil?
        end

        it 'stores no notifications' do
          obj.call params
          expect(obj.notifications).must_be :empty?
        end
      end
    end # describe 'when called while a user is'

    describe 'when called with a user name that is' do
      let(:authoriser) { Struct.new(:guest?).new true }

      describe 'already present, it' do
        let(:user_present) { true }

        it 'returns :precondition_failed' do
          expect(obj.call params).must_equal :precondition_failed
        end
      end # describe 'already present, it'

      describe 'not present, it' do
        let(:user_present) { false }

        it 'returns a User instance' do
          expect(obj.call params).must_be_instance_of user_class
        end
      end # describe 'not present, it'
    end # describe 'when called with a user name that is'

    describe 'when persisting a newly-built User entity, if' do
      describe 'the save attempt is unsuccessful' do
        let(:save_succeeds) { false }
        let(:authoriser) { Struct.new(:guest?).new true }

        it 'returns :save_failed' do
          expect(obj.call params).must_equal :save_failed
        end
      end # describe 'the save attempt is unsuccessful'
    end # describe 'when persisting a newly-built User entity, if'
  end # describe 'has a #call instance method that'
end