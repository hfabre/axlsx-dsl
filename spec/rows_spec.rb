describe "Building Rows" do
  before do
    @package = Axlsx::Package.new
    @workbook = @package.workbook
    @style = Axlsx::DSL::StyleSheet.new(@workbook)
    @sheet = Axlsx::DSL::Sheet.new(@workbook, @style)
  end

  describe "a simple row" do

    before do
      @row = @sheet.row do |r|
        r.cell 'foo'
        r.cell 'bar'
      end
    end

    it "has cells" do
      @row.cells.size.should eq(2)
      @row.cells.each do |cell|
        cell.should be_kind_of(Axlsx::DSL::Cell)
      end
    end

    it "has axlsx cells" do
      @row.xcells.size.should eq(2)
      @row.xcells.each do |cell|
        cell.should be_kind_of(Axlsx::Cell)
      end
    end

    describe "cells" do

      it "has coordinates" do
        @row.cells.first.r.should eq("A1")
        @row.cells.last.r.should eq("B1")
      end

      it "has axlsx cell" do
        @row.cells.each_with_object(["A", "B"]) do |cell, col|
          xcell = cell.xcell
          xcell.should be_kind_of(Axlsx::Cell)
          xcell.r.should eq("#{col.shift}1")
        end
      end

    end

  end
end