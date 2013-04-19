require 'spec_helper'

describe Axlsx::DSL::Sheet do

  before do
    @package = Axlsx::Package.new
    @workbook = @package.workbook
    @style = Axlsx::DSL::StyleSheet.new(@workbook)
  end

  it "is initialized with a workbook and dsl style sheet" do
    @sheet = Axlsx::DSL::Sheet.new(@workbook, @style)
    @sheet.should be
  end

  it "has a name option" do
    name = 'foo'
    @sheet = Axlsx::DSL::Sheet.new(@workbook, @style, :name => name)
    @sheet.name.should eq(name)
    @sheet.xworksheet.name.should eq(name)
  end

end
