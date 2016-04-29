# frozen_string_literal: true

require 'test_helper'

require 'prolog/entities/article_ident'

describe 'Prolog::Entities::ArticleIdent' do
  let(:described_class) { Prolog::Entities::ArticleIdent }
  let(:params) { { author_name: author_name, title: title } }
  let(:author_name) { 'Sam Quentin' }
  let(:title) { 'A Title' }

  describe 'must be initialised with a parameter value for' do
    after do
      params.delete @param
      error_class = Virtus::CoercionError
      error = expect { described_class.new params }.must_raise error_class
      expected = "Failed to coerce attribute `#{@param}' from nil into String"
      expect(error.message).must_equal expected
    end

    it ':title' do
      @param = :title
    end

    it 'author_name' do
      @param = :author_name
    end
  end # describe 'must be initialised with a parameter value for'

  it 'has a #to_s method that returns a YAML dump of the attributes' do
    actual = described_class.new(params).to_s
    expect(actual).must_equal YAML.dump(params)
  end
end
