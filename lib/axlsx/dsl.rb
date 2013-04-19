require 'axlsx/dsl/version'
require 'active_support/core_ext/module/delegation'

module Axlsx::DSL

  autoload :StyleSheet, 'axlsx/dsl/style_sheet'
  autoload :Sheet,      'axlsx/dsl/sheet'
  autoload :Row,        'axlsx/dsl/row'
  autoload :Cell,       'axlsx/dsl/cell'

end
