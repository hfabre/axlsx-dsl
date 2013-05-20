module Axlsx::DSL

  class StyleSheet

    class LookupError < StandardError
    end

    DEFAULT_KEY = :__default__
    SEPARATOR = '+'
    attr_reader :defs

    def initialize(workbook, options={})
      @store = {}
      @defs = {}
      @workbook = workbook
      store_style(DEFAULT_KEY, options[:default_style] || {})
    end

    def default_style
      @defs[DEFAULT_KEY]
    end

    def register(name, style)
      raise ArgumentError.new("style name already taken #{name}") if
        @store.include?(name)
      exts = [DEFAULT_KEY]
      extends = [style.delete(:extend)].flatten.compact
      exts += extends unless extends.blank?
      style = exts.inject({}) do |s, e|
        defn = @defs[e] or raise LookupError.new(e.inspect)
        s.deep_merge(defn)
      end.deep_merge(style)
      store_style name, style
    end

    alias_method :[]=, :register

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

  protected

    def store_style(key, style)
      @defs[key] = style
      @store[key] = @workbook.styles.add_style(style.deep_dup)
    end

    def lookup_composed(keys)
      key = keys.join(SEPARATOR)
      return @store[key] if @store.has_key?(key)
      style = keys.inject({}) do |h, k|
        s = @defs[k] or raise LookupError.new(k.inspect)
        h.merge s
      end
      register(key, style)
    end

  end

end
