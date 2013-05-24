module Axlsx::DSL

  class Sheet
    attr_reader :xworkbook
    attr_reader :xworksheet
    attr_reader :style
    attr_reader :rows
    attr_reader :refs

    delegate :merge_cells, :add_row, :add_image, :name, :name=, :column_widths,
      :to => :@xworksheet

    def initialize(xworkbook, stylesheet, options={})
      @xworkbook = xworkbook
      @xworksheet = @xworkbook.add_worksheet
      @xworksheet.name = options[:name] if options[:name]
      @style = stylesheet
      @refs = {}
      @rows = []
    end

    def row(*args, &block)
      r = Row.new(self, *args, &block)
      @rows << r
      r
    end

    # add a reference to the cell
    def add_ref(name, cell)
      @refs[name.to_sym] = cell
    end

    # get reference coordinates
    def ref(name, abs=false)
      cell = @refs[name.to_sym]
      unless cell.nil?
        if abs
          "'#{@xworksheet.name}'!#{cell.r}"
        else
          cell.r
        end
      else
        nil
      end
    end

    def image(img_path, width, height, left, right)
      @xworksheet.add_image( :image_src => img_path ) do |image|
        image.width = width
        image.height = height
        image.start_at left, right
      end
    end

    def inspect
      "<#{self.class.name} 0x#{object_id.to_s(16)}>"
    end

  end

end
