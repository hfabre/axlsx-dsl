module Axlsx::DSL

  class Sheet
    attr_reader :worksheet
    attr_reader :stylesheet
    attr_reader :rows

    delegate :merge_cells, :to => :@worksheet

    def initialize(worksheet, stylesheet)
      @worksheet = worksheet
      @stylesheet = stylesheet
      @rows = []
    end

    alias_method :ss, :stylesheet

    def row(*args, &block)
      r = Row.new(self, *args, &block)
      @rows << r
      r
    end

    def image(img_path, width, height, left, right)
      @worksheet.add_image( :image_src => img_path ) do |image|
        image.width = width
        image.height = height
        image.start_at left, right
      end
    end

  end

end