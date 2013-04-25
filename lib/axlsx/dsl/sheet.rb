module Axlsx::DSL

  class Sheet
    attr_reader :xworkbook
    attr_reader :xworksheet
    attr_reader :style
    attr_reader :rows
    attr_reader :refs

    delegate :merge_cells, :add_row, :name, :name=,
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

    def image(img_path, width, height, left, right)
      @xworksheet.add_image( :image_src => img_path ) do |image|
        image.width = width
        image.height = height
        image.start_at left, right
      end
    end

  end

end
