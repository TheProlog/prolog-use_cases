# frozen_string_literal: true

require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution/attributes'

describe 'Prolog::UseCases::ProposeEditContribution::Attributes' do
  let(:described_class) do
    Prolog::UseCases::ProposeEditContribution::Attributes
  end
  let(:article) do
    Struct.new(:author_name, :title).new author_name, title
  end
  let(:author_name) { 'j Random Author' }
  let(:title) { 'A Title' }
  let(:endpoints) { (0..-1) }
  let(:justification) { 'Just because.' }
  let(:proposed_at) { nil } # use default value
  let(:proposed_by) { 'P Random Member' }
  let(:proposed_content) { '<p>Complete replacement.</p>' }
  let(:obj) { described_class.new params }
  let(:params) do
    { article: article, endpoints: endpoints, justification: justification,
      proposed_content: proposed_content, proposed_at: proposed_at,
      proposed_by: proposed_by }
  end

  describe 'initialisation' do
    describe 'with a complete set of valid parameters' do
      it 'succeeds' do
        expect(described_class.new params).must_be_instance_of described_class
      end
    end # describe 'with a complete set of valid parameters'

    describe 'supplies expected default values for omitted parameters for' do
      it ':justification' do
        params[:justification] = nil
        expect(obj.justification).must_equal ''
      end

      it ':endpoints' do
        params[:endpoints] = nil
        expected = (-1..-1)
        expect(obj.endpoints).must_equal expected
      end
    end # describe 'supplies expected default values for omitted parameters for'
  end # describe ';nitialisation'

  describe 'has an #article_id method that' do
    let(:article_id) { obj.article_id }

    it 'returns a Hash-like object' do
      expect(article_id).must_respond_to :to_hash
    end

    describe 'has hash entries for' do
      it ':author_name' do
        expect(article_id[:author_name]).must_equal author_name
      end

      it ':title' do
        expect(article_id[:title]).must_equal title
      end
    end # describe 'has hash entries for'

    describe 'has Struct-like reader methods for' do
      it ':author_name' do
        expect(article_id.author_name).must_equal author_name
      end

      it ':title' do
        expect(article_id.title).must_equal title
      end
    end # describe 'has Struct-like reader methods for'
  end # describe 'has an #article_id method that'
end
