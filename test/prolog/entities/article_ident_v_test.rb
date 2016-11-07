# frozen_string_literal: true

require 'test_helper'

require 'prolog/entities/article_ident_v'

describe 'Prolog::Entities::ArticleIdentV' do
  let(:described_class) { Prolog::Entities::ArticleIdentV }
  let(:params) { { author_name: author_name, title: title } }
  let(:author_name) { 'Sam Quentin' }
  let(:title) { 'A Title' }

  describe 'when initialised' do
    describe 'must have a parameter value for' do
      after do
        params.delete @param
        error_class = Dry::Struct::Error
        error = expect { described_class.new params }.must_raise error_class
        expected = "[#{described_class}.new] :#{@param} " \
          'is missing in Hash input'
        expect(error.message).must_equal expected
      end

      it ':title' do
        @param = :title
      end

      it 'author_name' do
        @param = :author_name
      end
    end # describe 'must have a parameter value for'

    describe 'with valid parameter values for :title and for :author_name' do
      let(:obj) { described_class.new params }

      describe 'it has reader methods for the values for' do
        it '#title' do
          expect(obj.title).must_equal title
        end

        it '#author_name' do
          expect(obj.author_name).must_equal author_name
        end
      end # describe 'it has reader methods for the values for'

      it 'has a #to_hash value conversion method' do
        expect(obj.to_hash).must_equal params
      end
    end # describe 'with valid parameter values for :title and for :author_name'
  end # describe 'when initialised'

  it 'has a #to_s method that returns a YAML dump of the attributes' do
    actual = described_class.new(params).to_s
    expect(actual).must_equal YAML.dump(params)
  end
end
