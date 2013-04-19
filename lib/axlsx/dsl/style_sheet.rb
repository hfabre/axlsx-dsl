module Axlsx::DSL

  class StyleSheet

    class LookupError < StandardError
    end

    SEPARATOR = '+'

    def initialize(workbook)
      @store = {}
      @defs = {}
      @workbook = workbook
    end

    def register(name, style)
      raise ArgumentError.new("style name already taken #{name}") if
        @store.include?(name)
      if ext = style.delete(:extend)
        exts = Array[ext].flatten
        style = exts.inject(style) do |s, e|
          defn = @defs[e] or raise LookupError.new(k.inspect)
          defn.merge(s)
        end
      end
      @defs[name] = style
      @store[name] = @workbook.styles.add_style(style)
    end

    alias_method :[]=, :register

    def lookup_composed(keys)
      key = keys.join(SEPARATOR)
      return @store[key] if @store.has_key?(key)
      style = keys.inject({}) do |h, k|
        s = @defs[k] or raise LookupError.new(k.inspect)
        h.merge s
      end
      register(key, style)
    end

    def lookup(keys)
      if keys.kind_of?(Array)
        if keys.size > 1
          return lookup_composed(keys)
        else
          return lookup(keys.first)
        end
      end
      @store[keys] or raise LookupError.new(keys.inspect)
    end

    alias_method :[], :lookup
  end

end
