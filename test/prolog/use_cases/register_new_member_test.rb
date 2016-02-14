
require 'test_helper'

require 'ffaker'

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
      { name: user_name, email: email, profile: profile, password: password,
        confirmation: confirmation }
    end
    let(:email) { FFaker::Internet.safe_email }
    let(:password) { FFaker::Internet.slug }
    let(:confirmation) { password }
    let(:profile) { FFaker::HipsterIpsum.paragraph }
    let(:user_name) do
      [FFaker::Name.first_name, FFaker::Name.last_name].join ' '
    end
    let(:auth_listener) do
      Class.new do
        include Wisper::Publisher

        attr_reader :count

        def initialize(user_name)
          @user_name = user_name
          @count = 0
          self
        end

        def current_user
          @count += 1
          broadcast :current_user_is, user_name
          self
        end

        private

        attr_reader :user_name
      end.new current_user_name
    end
    let(:current_user_name) { 'Foghorn Leghorn' }

    it 'queries for the current logged-in user' do
      obj.subscribe auth_listener
      obj.call params
      expect(auth_listener.count).must_equal 1
    end
  end # describe 'has a #call instance method that'
end
