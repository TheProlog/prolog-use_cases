
require 'test_helper'

require 'prolog/use_cases/summarise_content'

describe 'Prolog::UseCases::SummariseContent' do
  let(:described_class) { Prolog::UseCases::SummariseContent }

  it 'has a #call instance method taking no parameters' do
    method = described_class.new.method(:call)
    expect(method.arity).must_equal 0
  end
end
