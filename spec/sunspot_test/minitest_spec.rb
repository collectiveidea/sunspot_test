require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "minitest.rb" do
  before(:each) do
    stub_const('MiniTest::Unit', Class.new)
    stub_const("MiniTest::Unit::VERSION", '2.11.1')
    SunspotTest.stub!(:setup_solr)
  end

  after(:all) do
    SunspotTest.custom_module_name = nil
  end

  context "with MiniTest::Unit version that's too old" do
    it "raises an exception" do
      stub_const("MiniTest::Unit::VERSION", '2.10.9')
      expect {
        load File.expand_path(File.dirname(__FILE__) + '/../../lib/sunspot_test/minitest.rb')
      }.to raise_error(RuntimeError)
    end
  end

  describe "SunspotTest::MiniTest" do
    describe ".set_kill_server_callback" do
      it "should call MiniTest::Unit.after_tests (instead of Kernel#at_exit)" do
        MiniTest::Unit.class_eval do
          def self.after_tests(&block)
            yield
          end
        end

        block_obj = double
        block_obj.should_receive(:foo)
        #SunspotTest.stub!(:setup_solr)
        load File.expand_path(File.dirname(__FILE__) + '/../../lib/sunspot_test/minitest.rb')
        SunspotTest::MiniTest.set_kill_server_callback { block_obj.foo }
      end
    end
  end

  it "sets SunspotTest.custom_module_name to 'SunspotTest::MiniTest'" do
    SunspotTest.should_receive(:custom_module_name=).with('SunspotTest::MiniTest')
    load File.expand_path(File.dirname(__FILE__) + '/../../lib/sunspot_test/minitest.rb')
  end

end
