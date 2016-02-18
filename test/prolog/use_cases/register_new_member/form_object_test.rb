
require 'test_helper'

require 'ffaker'

require 'prolog/use_cases/register_new_member/form_object'

describe 'Prolog::UseCases::RegisterNewMember::FormObject' do
  let(:described_class) { Prolog::UseCases::RegisterNewMember::FormObject }
  let(:params) do
    { name: user_name, email: email, profile: profile, password: password,
      password_confirmation: password_confirmation }
  end
  let(:email) { FFaker::Internet.safe_email name }
  let(:password) { FFaker::Internet.password }
  let(:password_confirmation) { password }
  let(:profile) { FFaker::HipsterIpsum.phrase }
  let(:user_name) { 'John Doe' }

  describe 'validates initialisation attributes such that when supplied with' do
    let(:obj) { described_class.new params }
    describe 'complete, valid attributes, it reports' do
      it 'being valid' do
        expect(obj).must_be :valid?
      end

      it 'no errors' do
        obj.valid?
        expect(obj.errors).must_be :empty?
      end
    end # describe 'complete, valid attributes, it reports'

    describe 'attributes not including' do
      # FIXME: This *ought* not to be difficult to DRY up.
      #        However, we get odd variations in ActiveModel's reporting of
      #        validation errors between running this test file individually and
      #        running it as part of the full suite. Hilarity ensued. This
      #        appears to be new behaviour to ActiveModel 4.2.5.1, by the way.
      describe ':name, it reports' do
        before do
          params.delete :name
          obj.valid?
        end

        it 'being invalid' do
          expect(obj).must_be :invalid?
        end

        # Repeated error messages with full test, not unit test; why?!?
        it 'the correct error message' do
          expect(obj.errors[:name]).must_include 'is invalid'
        end
      end # describe ':name, it reports'

      describe ':email, it reports' do
        before do
          params.delete :email
          obj.valid?
        end

        it 'being invalid' do
          expect(obj).must_be :invalid?
        end

        it 'the correct error message' do
          expected = ['does not appear to be valid']
          expect(obj.errors[:email]).must_equal expected
        end
      end # describe ':email, it reports'

      describe ':password, it reports' do
        before do
          params.delete :password
          obj.valid?
        end

        it 'being invalid' do
          expect(obj).must_be :invalid?
        end

        describe 'the correct error message' do
          let(:expected) do
            { password_confirmation: ["doesn't match Password"],
              password: ['is too short (minimum is 8 characters)'] }
          end

          it 'keys' do
            expect(obj.errors.messages.keys.sort).must_equal expected.keys.sort
          end

          it 'message strings' do
            actual = {}
            expected.keys.each do |key|
              actual[key] = obj.errors.messages[key].uniq
            end
            expect(actual).must_equal expected
          end
        end # describe 'the correct error message'
      end # describe ':password, it reports'

      describe ':password_confirmation, it reports' do
        before do
          params.delete :password_confirmation
          obj.valid?
        end

        it 'being invalid' do
          expect(obj).must_be :invalid?
        end

        it 'the correct error message' do
          expected = ["can't be blank"]
          actual = obj.errors.messages[:password_confirmation]
          expect(actual).must_equal expected
        end
      end # describe ':password_confirmation, it reports'
    end # describe 'attributes not including'
  end # describe 'validates ... attributes such that when supplied with'

  describe 'has an #error_notifications method that when called on' do
    let(:obj) { described_class.new params }

    describe 'a valid object' do
      it 'returns an empty Hash' do
        expect(obj.error_notifications).must_equal({})
      end
    end # describe 'a valid object'

    describe 'an invalid object with' do
      let(:actual) { obj.error_notifications }
      describe 'one error, returns a Hash with a single' do
        before do
          params[:name] = 'Invalid    Name'
        end

        it 'key' do
          expect(actual.keys).must_equal [:name]
        end

        it 'message string' do
          expect(actual[:name]).must_equal ['is invalid']
        end
      end # describe 'one error, returns a Hash with a single'

      describe 'multiple errors, returns a Hash with the correct multiple' do
        before do
          params[:name] = 'Invalid   User'
          params[:email] = 'invalid email at nowhere possible'
          params[:password_confirmation] = 'bogusify'
        end

        it 'keys' do
          expected = [:email, :name, :password_confirmation]
          expect(actual.keys.sort).must_equal expected
        end

        it 'message strings in a correctly-keyed Hash' do
          expected = { name: ['is invalid'],
                       email: ['does not appear to be valid'],
                       password_confirmation: ["doesn't match Password"] }
          expect(actual).must_equal expected
        end
      end # describe 'multiple errors, returns a Hash with the correct multiple'
    end # describe 'an invalid object with'
  end # describe 'has an #error_notifications method that when called on'
end
