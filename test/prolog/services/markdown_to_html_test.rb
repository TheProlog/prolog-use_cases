
require 'test_helper'

require 'prolog/services/markdown_to_html'

describe 'Prolog::Services::MarkdownToHtml' do
  let(:described_class) { Prolog::Services::MarkdownToHtml }

  it 'accepts a :wrap_with parameter for initialisation' do
    expect { described_class.new wrap_with: :section }.must_be_silent
  end

  describe 'may be initialised with a :wrap_with parameter that' do
    it 'may be omitted' do
      expect { described_class.new }.must_be_silent
    end

    it 'may be supplied as a symbol' do
      expect { described_class.new wrap_with: :foo }.must_be_silent
    end

    it 'populates a :wrap_with attribute on the object' do
      obj = described_class.new wrap_with: :foo
      expect(obj.wrap_with).must_equal :foo
    end

    it 'defaults to :div' do
      expect(described_class.new.wrap_with).must_equal :div
    end
  end # describe 'may be initialised with a :wrap_with parameter that'

  describe 'has a :content attribute that' do
    it 'may be read' do
      expect(described_class.new).must_respond_to :content
    end

    it 'may not be set' do
      expect(described_class.new).wont_respond_to :content=
    end
  end # describe 'has a :content attribute that'

  it 'has a #call method' do
    expect(described_class.new).must_respond_to :call
  end

  describe 'has a #call method that' do
    let(:obj) { described_class.new }

    it 'requires a :content parameter' do
      error = expect { obj.call }.must_raise ArgumentError
      expect(error.message).must_equal 'missing keyword: content'
    end

    it 'sets the :content attribute' do
      expect(obj.content).must_be :nil?
      obj.call content: 'This is content.'
      expect(obj.content).wont_be :nil?
    end

    describe 'sets the :content attribute such that' do
      before do
        obj.call content: 'This is *content*.'
      end

      it 'can be parsed as XML/HTML' do
        expect { Ox.parse obj.content }.must_be_silent
      end

      it 'has the correct wrapper element' do
        obj2 = described_class.new wrap_with: :section
        markup = obj2.call(content: 'This is *content*.').content
        content = Ox.parse markup
        expect(content.name).must_equal 'section'
      end
    end # describe 'sets the :content attribute such that'
  end # describe 'has a #call method that'
end
