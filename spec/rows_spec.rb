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
        @row.cells.each_with_object(["A", "B"]) do |cell, cols|
          xcell = cell.xcell
          xcell.should be_kind_of(Axlsx::Cell)
          xcell.r.should eq("#{cols.shift}1")
        end
      end

    end

  end

  describe "row spans" do

    it "spans to the right" do
      row = @sheet.row do |r|
        r.cell
        r.cell 'foo', :row_span => 3
      end

      row.cells.size.should eq(2)
      row.xcells.size.should eq(4)
      row.cells.first.xcells.map(&:r).should eq(%w[A1])
      row.cells.last.xcells.map(&:r).should eq(%w[B1 C1 D1])
    end

    it "spans from first cell" do
      row = @sheet.row do |r|
        r.cell 'foo', :row_span => 3
        r.cell 'bar'
      end

      row.cells.size.should eq(2)
      row.xcells.size.should eq(4)
      row.cells.first.xcells.map(&:r).should eq(%w[A1 B1 C1])
      row.cells.last.xcells.map(&:r).should eq(%w[D1])
    end

    it "spans from the middle" do
      row = @sheet.row do |r|
        r.cell 'foo'
        r.cell 'bar', :row_span => 3
        r.cell 'baz', :row_span => 2
        r.cell
      end
      row.cells.size.should eq(4)
      row.xcells.size.should eq(7)
      row.cells[0].xcells.map(&:r).should eq(%w[A1])
      row.cells[1].xcells.map(&:r).should eq(%w[B1 C1 D1])
      row.cells[2].xcells.map(&:r).should eq(%w[E1 F1])
      row.cells[3].xcells.map(&:r).should eq(%w[G1])
    end

  end

  describe "references" do
    before do
      @sheet.row do |r|
        r.cell 'foo', :as => :foo
        r.cell 'bar', :as => :bar
      end
    end

    it "can retrieve references" do
      @sheet.refs[:foo].r.should eq('A1')
      @sheet.refs[:bar].r.should eq('B1')
    end

    it "keep the last one" do
      @sheet.row do |r|
        r.cell 'foo 2', :as => :foo
        r.cell 'baz', :as => :baz
      end

      @sheet.refs[:foo].r.should eq('A2')
    end
  end
end
