require 'axlsx/dsl/version'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/deep_dup.rb'
require 'active_support/core_ext/hash/deep_merge.rb'
require 'active_support/core_ext/object/blank'

module Axlsx::DSL

  autoload :StyleSheet, 'axlsx/dsl/style_sheet'
  autoload :Sheet,      'axlsx/dsl/sheet'
  autoload :Row,        'axlsx/dsl/row'
  autoload :Cell,       'axlsx/dsl/cell'

end
