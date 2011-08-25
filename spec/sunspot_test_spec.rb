require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SunspotTest do
  describe ".solr_startup_timeout" do
    after(:all) { SunspotTest.solr_startup_timeout = 15 }
    it "defaults to 15" do
      SunspotTest.solr_startup_timeout.should eq(15)
    end

    it "can be set using .solr_startup_timeout=" do
      SunspotTest.solr_startup_timeout = 20
      SunspotTest.solr_startup_timeout.should eq(20)
    end
  end

  describe "setup_solr" do
    it "calls unstub and start_sunspot_server" do
      SunspotTest.should_receive(:unstub)
      SunspotTest.should_receive(:start_sunspot_server)
      SunspotTest.setup_solr
    end
  end

  describe "server" do
    it "creates a new Sunspot Rails Server" do
      Sunspot::Rails::Server.should_receive(:new)
      SunspotTest.server
    end
  end

  describe ".start_sunspot_server" do
    context "if server is already started" do
      before(:each) { SunspotTest.stub!(:solr_running? => true) }

      it "does not try to spin up another server" do
        Kernel.should_not_receive(:fork)
        SunspotTest.start_sunspot_server
      end
    end

    context "if the server has NOT been started" do
      before(:all) do
        SunspotTest.stub!(:wait_until_solr_starts) { true }
      end

      before(:each) do
        SunspotTest.server = nil

        fake_server = mock("server")
        SunspotTest.stub!(:server) { fake_server }
      end

      # was getting funky issues when the test was broken up
      it "forks the process, redirects stdout/stderr, runs server, sets exit hook, waits for server" do

        SunspotTest.should_receive(:fork) do |&block|
          STDERR.should_receive(:reopen).with("/dev/null")
          STDOUT.should_receive(:reopen).with("/dev/null")
          SunspotTest.server.should_receive(:run)
          block.call
        end

        SunspotTest.should_receive(:at_exit) do |&block|
          Process.should_receive(:kill)
          block.call
        end

        SunspotTest.should_receive(:wait_until_solr_starts)
        SunspotTest.start_sunspot_server
      end
    end

    describe ".stub" do
      context "if the session is already stubbed" do
        before(:each) { SunspotTest.instance_variable_set(:@session_stubbed, true) }

        it "does nothing" do
          Sunspot::Rails::StubSessionProxy.should_not_receive(:new)

          SunspotTest.stub
        end
      end

      context "if the session is not currently stubbed" do
        before(:each) { SunspotTest.instance_variable_set(:@session_stubbed, false) }

        it "stubs the Sunspot session and sets @session_stubbed to true" do
          Sunspot::Rails::StubSessionProxy.should_receive(:new)

          SunspotTest.stub
        end

        it "sets @session_stubbed to true" do
          SunspotTest.stub
          SunspotTest.instance_variable_get(:@session_stubbed).should eq(true)
        end
      end
    end

    describe ".unstub" do
      context "if the session is not stubbed" do
        before(:each) { SunspotTest.instance_variable_set(:@session_stubbed, false) }
        it "does nothing" do
          SunspotTest.should_not_receive(:original_sunspot_session)
          SunspotTest.unstub
        end
      end

      context "if the session is currently stubbed" do
        before(:each) { SunspotTest.instance_variable_set(:@session_stubbed, true) }

        it "sets the Sunspot session to the original session" do
          SunspotTest.should_receive(:original_sunspot_session)

          SunspotTest.unstub
        end

        it "sets @session_stubbed to true" do
          SunspotTest.unstub
          SunspotTest.instance_variable_get(:@session_stubbed).should eq(false)
        end
      end
    end

    describe ".solr_running" do
      context "if solr is running" do
        before(:each) { Net::HTTP.stub!(:get).and_return(true) }

        it "returns true" do
          SunspotTest.send(:solr_running?).should eq(true)
        end
      end

      context "if solr is not running" do
        it "returns false" do
          SunspotTest.send(:solr_running?).should eq(false)
        end
      end
    end
    describe ".wait_until_solr_starts" do
      context "if solr never starts" do
        before(:each) { SunspotTest.solr_startup_timeout = 2 }

        it "calls solr_running? until solr_startup_timeout raises TimeOutError" do
          SunspotTest.should_receive(:solr_running?).exactly((SunspotTest.solr_startup_timeout * 10) + 1).times

          lambda { SunspotTest.send(:wait_until_solr_starts) }.should raise_error SunspotTest::TimeOutError, "Solr failed to start after #{SunspotTest.solr_startup_timeout} seconds"
        end
      end

      context "if solr is started" do
        it "calls solr_running? and returns" do
          SunspotTest.should_receive(:solr_running?).exactly(2).times.and_return(true)

          lambda { SunspotTest.send(:wait_until_solr_starts) }.should_not raise_error
        end
      end
    end
  end
end
