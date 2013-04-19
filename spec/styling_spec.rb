require 'spec_helper'

describe "Axlsx DSL Styling" do

  before do
    @package = Axlsx::Package.new
    @workbook = @package.workbook
    @style = Axlsx::DSL::StyleSheet.new(@workbook)
  end

  describe 'definitions' do

    it "defines simple styles" do
      @style[:strong] = {:b => true}
    end

    it "define composed styles" do
      @style.register([:strong, :date],
        {:b => true, :format_code=> "DD/MM/YYYY"})
    end

  end

  describe "lookup" do

    before do
      @style[:strong] = {:b => true}
      @style[:date] = {:format_code=> "DD/MM/YYYY"}
      @style.register([:strong, :date], {
        :b => true,
        :format_code=> "DD/MM/YYYY"})
    end

    it "looks up simple styles" do
      @style[:strong].should be
      @style.lookup(:strong).should be
    end

    it "looks up composed styles" do
      @style.lookup([:strong, :date]).should be
    end

  end

  describe "using" do

    before do
      @style[:strong] = {:b => true}
      @style[:date] = {:format_code=> "DD/MM/YYYY"}

      @sheet = Axlsx::DSL::Sheet.new(@workbook, @style)
    end

    describe "cells" do

      it "has a style" do

        row = @sheet.row do |r|
          r.cell :style => :strong
        end

        row.cells.first.style.should eq([:strong])
      end

    end

    describe "rows" do
      it "has default style for each cell"
    end

  end

end
