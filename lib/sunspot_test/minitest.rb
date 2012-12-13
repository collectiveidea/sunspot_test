if Gem::Version.new(MiniTest::Unit::VERSION) < Gem::Version.new('2.11.1')
  raise "Detected MiniTest #{MiniTest::Unit::VERSION}; must use version 2.11.1 or greater"
end

SunspotTest.module_eval do
  class << self
    def set_kill_server_callback(&block)
      MiniTest::Unit.after_tests &block
    end
  end
end

require 'sunspot_test/test_unit'