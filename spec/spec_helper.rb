$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'sunspot'
require 'sunspot_test'

RSpec.configure do |c|
  c.raise_errors_for_deprecations!
end
