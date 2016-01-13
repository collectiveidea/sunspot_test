require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SunspotTest do
  describe ".solr_startup_timeout" do
    after(:all) { SunspotTest.solr_startup_timeout = 15 }
    it "defaults to 15" do
      expect(SunspotTest.solr_startup_timeout).to eq(15)
    end

    it "can be set using .solr_startup_timeout=" do
      SunspotTest.solr_startup_timeout = 20
      expect(SunspotTest.solr_startup_timeout).to eq(20)
    end
  end

  describe "setup_solr" do
    it "calls unstub and start_sunspot_server" do
      expect(SunspotTest).to receive(:unstub)
      expect(SunspotTest).to receive(:start_sunspot_server)
      SunspotTest.setup_solr
    end
  end

  describe "server" do
    it "creates a new Sunspot Rails Server" do
      expect(Sunspot::Rails::Server).to receive(:new)
      SunspotTest.server
    end
  end

  describe ".start_sunspot_server" do
    context "if server is already started" do
      before do
        allow(SunspotTest).to receive(:solr_running?) { true }
      end

      it "does not try to spin up another server" do
        expect(Kernel).not_to receive(:fork)
        SunspotTest.start_sunspot_server
      end
    end

    context "if the server has NOT been started" do
      before do
        allow(SunspotTest).to receive(:wait_until_solr_starts) { true }
      end

      before do
        SunspotTest.server = nil

        fake_server = double("server")
        allow(SunspotTest).to receive(:server) { fake_server }
      end

      # was getting funky issues when the test was broken up
      it "forks the process, redirects stdout/stderr, runs server, sets exit hook, waits for server" do

        expect(SunspotTest).to receive(:fork) do |&block|
          expect(STDERR).to receive(:reopen).with("/dev/null")
          expect(STDOUT).to receive(:reopen).with("/dev/null")
          expect(SunspotTest.server).to receive(:run)
          block.call
        end

        expect(SunspotTest).to receive(:at_exit) do |&block|
          expect(Process).to receive(:kill)
          block.call
        end

        expect(SunspotTest).to receive(:wait_until_solr_starts)
        SunspotTest.start_sunspot_server
      end
    end

    describe ".stub" do
      context "if the session is already stubbed" do
        before do
          SunspotTest.instance_variable_set(:@session_stubbed, true)
        end

        it "does nothing" do
          expect(Sunspot::Rails::StubSessionProxy).not_to receive(:new)

          SunspotTest.stub
        end
      end

      context "if the session is not currently stubbed" do
        before do
          SunspotTest.instance_variable_set(:@session_stubbed, false)
        end

        it "stubs the Sunspot session and sets @session_stubbed to true" do
          expect(Sunspot::Rails::StubSessionProxy).to receive(:new)

          SunspotTest.stub
        end

        it "sets @session_stubbed to true" do
          SunspotTest.stub
          expect(SunspotTest.instance_variable_get(:@session_stubbed)).to eq(true)
        end
      end
    end

    describe ".unstub" do
      context "if the session is not stubbed" do
        before do
          SunspotTest.instance_variable_set(:@session_stubbed, false)
        end
        it "does nothing" do
          expect(SunspotTest).not_to receive(:original_sunspot_session)
          SunspotTest.unstub
        end
      end

      context "if the session is currently stubbed" do
        before do
          SunspotTest.instance_variable_set(:@session_stubbed, true)
        end

        it "sets the Sunspot session to the original session" do
          expect(SunspotTest).to receive(:original_sunspot_session)

          SunspotTest.unstub
        end

        it "sets @session_stubbed to true" do
          SunspotTest.unstub
          expect(SunspotTest.instance_variable_get(:@session_stubbed)).to eq(false)
        end
      end
    end

    describe ".solr_running" do
      context "if solr is running" do
        before do
          Net::HTTP.stub(get_response:double(code: '200'))
        end

        it "returns true" do
          expect(SunspotTest.send(:solr_running?)).to eq(true)
        end
      end

      context "if solr is not running" do
        it "returns false" do
          expect(SunspotTest.send(:solr_running?)).to eq(false)
        end
      end

      context "if solr is starting up" do
        before do
          Net::HTTP.stub(get_response:double(code: '503'))
        end

        it "returns false" do
          expect(SunspotTest.send(:solr_running?)).to eq(false)
        end
      end

    end
    describe ".wait_until_solr_starts" do
      context "if solr never starts" do
        before do
          SunspotTest.solr_startup_timeout = 2
        end

        it "calls solr_running? until solr_startup_timeout raises TimeOutError" do
          expect(SunspotTest).to receive(:solr_running?).exactly((SunspotTest.solr_startup_timeout * 10) + 1).times

          expect {
            SunspotTest.send(:wait_until_solr_starts) 
          }.to raise_error SunspotTest::TimeOutError, "Solr failed to start after #{SunspotTest.solr_startup_timeout} seconds"
        end
      end

      context "if solr is started" do
        it "calls solr_running? and returns" do
          expect(SunspotTest).to receive(:solr_running?).exactly(2).times.and_return(true)

          expect {
            SunspotTest.send(:wait_until_solr_starts)
          }.not_to raise_error
        end
      end
    end
  end
end
