require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "minitest.rb" do
  describe "with MiniTest::Unit version that's too old" do
    it "raises an exception" do
      stub_const("MiniTest::Unit::VERSION", '2.10.9')
      expect {
        load File.expand_path(File.dirname(__FILE__) + '/../../lib/sunspot_test/minitest.rb')
      }.to raise_error(RuntimeError)
    end
  end

  describe "with valid MiniTest version" do
    it "modifies behavior of SunspotTest.set_kill_server_callback (to call MiniTest::Unit.after_tests)" do
      stub_const('MiniTest::Unit', Class.new do
        def self.after_tests(&block)
          yield
        end
      end)
      stub_const('MiniTest::Unit::VERSION', '2.11.1')

      block_obj = double
      block_obj.should_receive(:foo)
      SunspotTest.stub!(:setup_solr)
      load File.expand_path(File.dirname(__FILE__) + '/../../lib/sunspot_test/minitest.rb')
      SunspotTest.set_kill_server_callback { block_obj.foo }
    end
  end
end
