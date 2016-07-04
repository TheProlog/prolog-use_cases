# frozen_string_literal: true

require 'test_helper'

require 'prolog/use_cases/accept_single_proposal/build_updated_body'

describe 'BuildUpdatedBody' do
  let(:described_class) { BuildUpdatedBody }
  let(:obj) { described_class.new valid_params }
  let(:valid_params) do
    { article: article, identifier: identifier,
      proposal: proposal }
  end
  let(:article) { :article_value }
  let(:identifier) { 'ACCEPTED-IDENTIFIER' }
  let(:proposal) { :proposal_value }

  describe 'initialisation' do
    it 'requires three parameters' do
      error = expect { described_class.new }.must_raise ArgumentError
      expected = /^missing keywords: \w+, \w+, \w+$/
      expect(error.message).must_match expected
    end

    describe 'requires parameters for' do
      let(:error) do
        begin
          described_class.new
        rescue ArgumentError => caught_err
          err = caught_err # silence RuboCop, blastit
        end
        err
      end

      after do
        param = name.split(/test_\d+_:/).last
        expect(error.message).must_match(/ #{param}/)
      end

      [:article, :identifier, :proposal].each do |param|
        it ":#{param}" do
        end
      end
    end # describe 'requires parameters for'
  end # describe 'initialisation'

  it 'has a #call method' do
    expect(obj).must_respond_to :call
  end

  describe 'has a #call method that' do
    let(:article) do
      body = %(<p>Blah #{proposed_mtp_begin}blah#{proposed_mtp_end}.</p>)
      Struct.new(:article_id, :body).new article_id, body
    end
    let(:article_id) { 'ARTICLE-ID' }
    let(:proposal) do
      params = [article_id, proposed_id, proposed_content]
      Struct.new(:article_id, :identifier, :proposed_content).new(*params)
    end
    let(:proposed_content) { 'PROPOSED CONTENT' }
    let(:proposed_id) { 'PROPOSED-IDENTIFIER' }
    let(:proposed_mtp_begin) do
      %(<a id="contribution-#{proposed_id}-begin"></a>)
    end
    let(:proposed_mtp_end) { %(<a id="contribution-#{proposed_id}-end"></a>) }

    it 'returns a String' do
      expect(obj.call).must_respond_to :to_str
    end

    describe 'returns a String that' do
      let(:result) { obj.call }

      it 'contains the accepted-contribution MTP with the correct ID' do
        mtp = AcceptedMTP.new identifier
        expect(result).must_match mtp.to_str
      end

      describe 'does not contain proposed-contribution MTPs for the' do
        after do
          mtp = ProposedMTP.new proposed_id, @which_end
          expect(result).wont_match mtp.to_str
        end

        it 'start of the selected content' do
          @which_end = :begin
        end

        it 'end of the selected content' do
          @which_end = :end
        end
      end # describe 'does not contain proposed-contribution MTPs for the'

      it 'contains the proposed content' do
        expect(result).must_match proposed_content
      end
    end # describe 'returns a String that'
  end # describe 'has a #call method that'
end
