module Axlsx::DSL

  class Cell
    attr_reader :style
    attr_reader :row_span
    attr_accessor :content
    attr_reader :xcell, :xcells
    attr_reader :alias

    delegate :value, :r, :r_abs, :reference, :pos,
      :to => :@xcell

    def initialize(row, *content, &block)
      options = content.extract_options!
      @style = Array[options[:style]].flatten.compact
      @content = content.first
      @row = row
      @row_span = options[:row_span] || 1
      @alias = options.delete(:as)
      @cell = nil
      @content = block if block_given?
    end

    def bind(xcells)
      @xcell = xcells.first
      @xcell.value = if @content.respond_to?(:call)
        @content.call
      else
        @content
      end
      @xcells = xcells
    end

    def inspect
      "<#{self.class.name} #{@xcell.nil? ? "0x#{object_id.to_s(16)}" : r}>"
    end

    def to_a
      a = Array.new(row_span)
      a[0] = @content unless @content.respond_to?(:call)
      a
    end

    def styles
      Array.new(row_span) { @style }
    end
  end

end