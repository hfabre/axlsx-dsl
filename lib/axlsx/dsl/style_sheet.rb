module Axlsx::DSL

  class StyleSheet

    class LookupError < StandardError
    end

    def initialize(workbook)
      @styles = {}
      @defs = {}
      @workbook = workbook
    end

    def register_style(name, style)
      raise ArgumentError.new("name already taken #{name}") if
        @styles.include?(name)
      if ext = style.delete(:extend)
        exts = Array[ext].flatten
        style = exts.inject(style) do |s, e|
          defn = @defs[e] or raise LookupError.new(k.inspect)
          defn.merge(s)
        end
      end
      @defs[name] = style
      @styles[name] = @workbook.styles.add_style(style)
    end

    alias_method :[]=, :register_style

    def composed_style(keys)
      key = keys.join("+")
      return @styles[key] if @styles.has_key?(key)
      style = keys.inject({}) do |h, k|
        s = @defs[k] or raise LookupError.new(k.inspect)
        h.merge s
      end
      register_style(key, style)
    end

    def style(keys)
      if keys.kind_of?(Array)
        if keys.size > 1
          return composed_style(keys)
        else
          return style(keys.first)
        end
      end
      @styles[keys] or raise LookupError.new(keys.inspect)
    end

    alias_method :[], :style
  end

end
