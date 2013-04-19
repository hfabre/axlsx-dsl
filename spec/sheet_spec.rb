require 'spec_helper'

describe Axlsx::DSL::Sheet do

  it "is initialized with a workbook and dsl style sheet" do
    @package = Axlsx::Package.new
    @workbook = @package.workbook
    @style = Axlsx::DSL::StyleSheet.new(@workbook)
    @sheet = Axlsx::DSL::Sheet.new(@workbook, @style)
    @sheet.should be
  end

end
