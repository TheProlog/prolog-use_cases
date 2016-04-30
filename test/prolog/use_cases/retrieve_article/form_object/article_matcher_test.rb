# frozen_string_literal: true

require 'test_helper'

require 'prolog/use_cases/retrieve_article/form_object/article_matcher'

describe 'Prolog::UseCases::RetrieveArticle::FormObject::ArticleMatcher' do
  let(:described_class) do
    Prolog::UseCases::RetrieveArticle::FormObject::ArticleMatcher
  end

  it 'has a .call method that takes a block as its only parameter' do
    method = described_class.method :call
    expect(method&.parameters&.first&.first).must_equal :block
  end

  describe 'has a .call method that returns' do
    let(:attribs) do
      { author_name: 'Author', body: 'A Body', image_url: 'image_url',
        keywords: [], title: 'A Title' }
    end

    it 'the single Article-like entity returned from the block' do
      article = OpenStruct.new(attribs).freeze
      expect(described_class.call { [article] }).must_equal article
    end

    it ':search_failure if block returns something not countable' do
      expect(described_class.call { 24 }).must_equal :search_failure
    end

    it ':non_specific_search_terms if block returns multiple items' do
      expected = :non_specific_search_terms
      expect(described_class.call { [1, 2] }).must_equal expected
    end

    describe ':not_an_article if block returns an object not responding to' do
      [:author_name, :body, :image_url, :keywords, :title].each do |attrib|
        it ":#{attrib}" do
          attribs.delete attrib
          obj = OpenStruct.new(attribs).freeze
          expect(described_class.call { [obj] }).must_equal :not_an_article
        end
      end
    end # describe ':not_an_article if block returns ... not responding to'
  end # describe 'has a .call method that returns'
end
