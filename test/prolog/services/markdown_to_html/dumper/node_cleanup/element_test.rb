
require 'test_helper'

require 'prolog/services/markdown_to_html/dumper/node_cleanup/element'

cls_name = Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup::Element

describe "#{cls_name}" do
  let(:described_class) { cls_name }

  # ########################################################################## #
  # #####                        INITIALISATION                          ##### #
  # ############################################################################

  it 'requires initialisation with an :element parameter' do
    error = expect { described_class.new }.must_raise ArgumentError
    expect(error.message).must_equal 'missing keyword: element'
  end
end
