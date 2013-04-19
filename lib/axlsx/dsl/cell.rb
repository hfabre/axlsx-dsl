module Axlsx::DSL

  class Cell
    attr_reader :row_span, :col_span
    attr_accessor :content

    attr_reader :xcell, :xcells
    attr_reader :options, :xoptions

    delegate :r, :pos, :to => :@xcell

    def initialize(row, *content, &block)
      options = content.extract_options!
      @options = options
      @content = content.first
      @row = row
      @row_span = @options[:row_span] || 1
      @col_span = @options[:col_span] || 1
      @cell = nil
      yield self if block_given?
    end

    def bind(xcells)
      @xcell = xcells.first
      @xcells = xcells
    end

    def to_a
      a = Array.new(row_span)
      a[0] = @content
      a
    end

    def styles
      Array.new(row_span) { @options[:style] }
    end
  end

end