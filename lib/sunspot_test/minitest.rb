if Gem::Version.new(MiniTest::Unit::VERSION) < Gem::Version.new('2.11.1')
  raise "Detected MiniTest #{MiniTest::Unit::VERSION}; must use version 2.11.1 or greater"
end

module SunspotTest
  module MiniTest
    class << self
      def set_kill_server_callback(&block)
        ::MiniTest::Unit.after_tests &block
      end
    end
  end
end

SunspotTest.custom_module_name = 'SunspotTest::MiniTest'

require 'sunspot_test/test_unit'