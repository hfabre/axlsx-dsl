require 'spec_helper'

describe "Axlsx DSL Styling" do

  before do
    @package = Axlsx::Package.new
    @workbook = @package.workbook
    @style = Axlsx::DSL::StyleSheet.new(@workbook)
  end

  describe "default styles" do

    before do
      @style = Axlsx::DSL::StyleSheet.new(@workbook,
        :default_style => {:font_name => 'Tahoma',
                           :family => 1,
                           :numFmt => 1})
    end

    it "reads default style" do
      @style.register :strong, :b => true
    end

    it "is extended by all styles" do
      @style.register :strong, :b => true, :numFmt => 2
      @style.defs[:strong].should eq(
        {:font_name => 'Tahoma', :family => 1, :b => true, :numFmt => 2})
    end

  end

  describe 'definitions' do

    it "defines simple styles" do
      @style[:strong] = {:b => true}
    end

    it "define composed styles" do
      @style.register([:strong, :date],
        {:b => true, :format_code=> "DD/MM/YYYY"})
    end

    describe "extends" do

      it "merge in order" do
        @style.register :one, :family => 1
        @style.register :two, :font_name => 'Tahoma', :b => true
        @style.register :three, :font_name => 'Helvetica'

        @style.register :four, :extend => [:one, :two, :three], :b => false
        @style.defs[:four].should eq(
          {:family => 1, :font_name => 'Helvetica', :b => false})
      end

    end

  end

  describe "lookup" do

    before do
      @style[:strong] = {:b => true}
      @style[:date] = {:format_code=> "DD/MM/YYYY"}
      @style.register([:strong, :date],
        :b => true,
        :format_code=> "DD/MM/YYYY")
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
      @style = Axlsx::DSL::StyleSheet.new(@workbook,
        :default_style => {:font_name => 'Tahoma',
                           :family => 1,
                           :numFmt => 1})

      @style[:strong] = {:b => true}
      @style[:date] = {:format_code=> "DD/MM/YYYY"}

      @sheet = Axlsx::DSL::Sheet.new(@workbook, @style)
    end

    describe "cells" do

      it "has a style" do
        row = @sheet.row do |r|
          r.cell :style => :strong
        end

        row.xcells.first.style.should eq(@style[:strong])
      end

      it "is applied default style" do
        row = @sheet.row do |r|
          r.cell :style => :strong
          r.cell
        end

        row.xcells.last.style.should eq(
          @style[Axlsx::DSL::StyleSheet::DEFAULT_KEY])
      end

    end

    describe "rows" do
      it "has default style for each cell" do
        row = @sheet.row(:style => :strong) do |r|
          r.cell :style => :date
          r.cell
        end

        row.xcells.first.style.should eq(@style.lookup([:strong, :date]))
        row.xcells.last.style.should eq(@style[:strong])
      end
    end

  end

end
