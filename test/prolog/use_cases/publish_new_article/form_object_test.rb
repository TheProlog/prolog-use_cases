# frozen_string_literal: true

require 'test_helper'

require 'ffaker'

require 'prolog/use_cases/publish_new_article/form_object'

def show_title_is_invalid
  it 'is invalid' do
    expect(obj).wont_be :valid?
  end

  it 'reports the :title as invalid' do
    expected = { title: ['is invalid'] }
    expect(obj.error_notifications).must_equal expected
  end
end

describe 'Prolog::UseCases::PublishNewArticle::FormObject' do
  let(:described_class) { Prolog::UseCases::PublishNewArticle::FormObject }
  let(:all_params) do
    { author_name: author_name, title: title, body: body,
      image_url: image_url, keywords: keywords, current_user: current_user }
  end
  let(:author_name) { 'Jane Doe' }
  let(:body) { FFaker::Lorem.paragraphs(rand(3..6)).join "\n" }
  let(:current_user) { author_name }
  let(:image_url) { "http://example.com/#{FFaker::Internet.slug}" }
  let(:keywords) { FFaker::HipsterIpsum.words rand(0..6) }
  let(:title) { FFaker::HipsterIpsum.phrase }
  let(:obj) { described_class.new all_params }

  describe 'when initialised with a complete set of field values and' do
    describe 'the current user is' do
      describe 'not the identified author' do
        let(:current_user) { 'Somebody Else' }

        before do
          obj.valid?
        end

        it 'the form object is not valid' do
          expect(obj).wont_be :valid?
        end

        it 'reports that the :author_name does not match the current user' do
          expected = { author_name: ['not current user'] }
          expect(obj.error_notifications).must_equal expected
        end
      end # describe 'not the identified author'

      describe 'the identified author' do
        it 'the form object is valid' do
          expect(obj).must_be :valid?
        end

        it 'reports no error notifications' do
          expect(obj.error_notifications).must_be :empty?
        end
      end # describe 'the identified author'
    end # describe 'the current user is'
  end # describe 'when initialised with a complete set of field values and'

  describe 'when initialised with field values where the' do
    describe ':author_name is' do
      describe 'missing, the form object' do
        before do
          all_params.delete :author_name
        end

        it 'is invalid' do
          expect(obj).wont_be :valid?
        end

        it 'reports the :author_name as not the current user' do
          expected = { author_name: ['not current user'] }
          expect(obj.error_notifications).must_equal expected
        end
      end # describe 'missing, the form object'
    end # describe ':author_name is'

    describe 'title' do
      describe 'is missing, the form object' do
        before do
          all_params.delete :title
        end

        show_title_is_invalid
      end # describe 'is missing, the form object'

      describe 'has leading whitespace, the form object' do
        before do
          all_params[:title] = '  Leading Spaces'
        end

        show_title_is_invalid
      end # describe 'has leading whitespace, the form object'

      describe 'has trailing whitespace, the form object' do
        before do
          all_params[:title] = 'Trailing Spaces   '
        end

        show_title_is_invalid
      end # describe 'has trailing whitespace, the form object'

      describe 'has extra whitespace, the form object' do
        before do
          all_params[:title] = 'Extra     Whitespace'
        end

        show_title_is_invalid
      end # describe 'has extra whitespace, the form object'
    end # describe 'title'

    describe 'image URL is' do
      describe 'valid and the body is missing' do
        before do
          all_params.delete :body
          obj.valid?
        end

        it 'the form object is valid' do
          expect(obj).must_be :valid?
        end

        it 'no errors are reported' do
          expect(obj.error_notifications).must_be :empty?
        end

        it 'the body is set to an empty string' do
          expect(obj.body).must_equal ''
        end
      end # describe 'valid and the body is missing'

      describe 'not valid and the body is' do
        before do
          all_params[:image_url] = 'This is not a valid URL.'
        end

        describe 'present' do
          it 'the form object is valid' do
            expect(obj).must_be :valid?
          end

          it 'no errors are reported' do
            obj.valid?
            expect(obj.error_notifications).must_be :empty?
          end

          it 'the image URL is set to an empty string' do
            obj.valid?
            expect(obj.image_url).must_equal ''
          end
        end # describe 'present'

        describe 'missing' do
          before do
            all_params.delete :body
            obj.valid?
          end

          it 'the form object is invalid' do
            expect(obj).wont_be :valid?
          end

          it 'the :image_url is reported as being invalid' do
            expected = {
              image_url: ['is not valid; it or body content must be']
            }
            expect(obj.error_notifications).must_equal expected
          end
        end # describe 'missing'
      end # describe 'not valid and the body is'
    end # describe 'image URL is'

    describe 'keywords include strings that' do
      describe 'have leading spaces' do
        let(:keywords) { ['  Testing', 'One', '  Two', 'Three'] }

        it 'removes leading spaces from keywords' do
          problems = obj.keywords.select { |str| str != str.lstrip }
          expect(problems).must_be :empty?
        end
      end # describe 'have leading spaces'

      describe 'have trailing spaces' do
        let(:keywords) { ['Testing  ', 'One', 'Two      ', 'Three'] }

        it 'removes trailing spaces from keywords' do
          problems = obj.keywords.select { |str| str != str.rstrip }
          expect(problems).must_be :empty?
        end
      end # describe 'have trailing spaces'

      describe 'have embedded spaces' do
        let(:keywords) { ['More  Testing', 'One', "Two\nAnd", "That's   All"] }

        it 'removes embedded spaces from keywords' do
          problems = obj.keywords.select { |str| str != str.gsub(/\s+/, ' ') }
          expect(problems).must_be :empty?
        end
      end # describe 'have embedded spaces'
    end # describe 'keywords include strings that'
  end # describe 'when initialised with field values where the'
end
