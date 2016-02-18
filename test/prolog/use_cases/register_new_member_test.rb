
require 'test_helper'

require 'ffaker'

require 'prolog/use_cases/register_new_member'

describe 'Prolog::UseCases::RegisterNewMember' do
  let(:described_class) { Prolog::UseCases::RegisterNewMember }
  let(:authoriser) { Object.new }
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

    describe 'when called while a user is' do
      describe 'logged in' do
        let(:authoriser) { Struct.new(:guest?).new false }

        it 'returns mil' do
          expect(obj.call).must_be :nil?
        end

        it 'stores a :failure notification indicating :already_logged_in' do
          obj.call
          expect(obj.notifications[:failure]).must_equal [:already_logged_in]
        end
      end # describe 'logged in'

      describe 'not logged in' do
        let(:authoriser) { Struct.new(:guest?).new true }
        let(:params) do
          { name: user_name, email: email, profile: profile, password: password,
            password_confirmation: password_confirmation }
        end
        let(:email) { FFaker::Internet.safe_email name }
        let(:password) { FFaker::Internet.password }
        let(:password_confirmation) { password }
        let(:profile) { FFaker::HipsterIpsum.phrase }
        let(:user_name) { FFaker::Name.name }

        it 'does not return nil' do
          expect(obj.call params).wont_be :nil?
        end

        it 'stores no notifications' do
          obj.call params
          expect(obj.notifications).must_be :empty?
        end
      end
    end # describe 'when called while a user is'
  end # describe 'has a #call instance method that'
end
