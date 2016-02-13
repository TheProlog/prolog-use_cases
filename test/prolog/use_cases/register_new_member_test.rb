
require 'test_helper'

require 'prolog/core'
require 'prolog/use_cases/register_new_member'

describe 'Prolog::UseCases::RegisterNewMember' do
  let(:described_class) { Prolog::UseCases::RegisterNewMember }
  let(:obj) { described_class.new }

  it 'has a #call instance method taking a variable parameter list' do
    method = obj.method(:call)
    expect(method.arity).must_equal(-1)
  end

  describe 'has a #call instance method that' do
    let(:params) do
      { name: 'Some User', email: 'user@example.com', password: 'password',
        confirmation: 'password', profile: 'Profile Text Here'
      }
    end

    describe 'requires parameter-hash entries including' do
      after do
        params.delete @omitted
        error = expect { obj.call params }.must_raise KeyError
        expect(error.message).must_equal "key not found: :#{@omitted}"
      end

      it ':name' do
        @omitted = :name
      end

      it ':email' do
        @omitted = :email
      end

      it ':password' do
        @omitted = :password
      end

      it ':confirmation' do
        @omitted = :confirmation
      end
    end # describe 'requires parameter-hash entries including'

    describe 'accepts parameter-hash entries including' do
      it ':profile' do
        expect { obj.call params }.must_be_silent
      end
    end # describe 'accepts parameter-hash entries including'
  end # describe 'has a #call instance method that'
end
