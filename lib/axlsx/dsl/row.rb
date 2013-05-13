module Axlsx::DSL

  class Row

    LOCAL_OPTIONS = [:style]

    attr_reader :style
    attr_reader :xrow
    attr_reader :cells, :xcells

    delegate :[], :[]=, :each, :to => :@cells
    include Enumerable

    def initialize(sheet, *cells, &block)
      options = cells.extract_options!
      @xoptions = options.slice!(*LOCAL_OPTIONS)
      @options = options
      if options[:style]
        @style = Array[options[:style]].flatten.map(&:to_sym)
      else
        @style = []
      end
      @sheet = sheet
      @cells = []
      cells.each{|c| cell(c)}
      yield self if block_given?
      @xrow = render
    end

    def xcells
      @xrow.cells
    end

    def cell(*args, &block)
      c = Cell.new(self, *args, &block)
      @cells.push c
      c
    end

    def size
      @cells.inject(0){|acc, cell| acc + cell.row_span}
    end

    def to_a
      @cells.inject([]) do |a, c|
        a += c.to_a
      end
    end

    def inspect
      "<#{self.class.name}>"
    end

    def styles
      @cells.inject([]) do |a, c|
        a += c.styles.map do |s|
          Array[@style + Array[s].flatten].flatten.compact
        end
      end
    end

  protected

    def render
      xstyles = styles.map{|s| @sheet.style.lookup(s) unless s.blank?}
      row = @sheet.add_row(to_a, @xoptions.merge(:style => xstyles))
      @cells.inject(0) do |offset, cell|
        @sheet.add_ref(cell.alias, cell) unless cell.alias.nil?
        if cell.row_span > 1
          cell_refs = row.cells[offset..(offset + cell.row_span - 1)]
          cell.bind(cell_refs)
          @sheet.merge_cells cell_refs
        else
          cell.bind([row.cells[offset]])
        end
        offset + cell.row_span
      end
      row
    end
  end
end