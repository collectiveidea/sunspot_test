require 'net/http'

Before("@searchrunning") do
  $sunspot = true
end

Before("@search") do
  unless $sunspot
    $sunspot = Sunspot::Rails::Server.new
    pid = fork do
      STDERR.reopen('/dev/null')
      STDOUT.reopen('/dev/null')
      $sunspot.run
    end
    # shut down the Solr server
    at_exit { Process.kill('TERM', pid) }
    SunspotHelpers.wait_until_solr_starts
  end
  
  Sunspot.remove_all!
  Sunspot.commit
end

AfterStep('@search') do
  Sunspot.commit
end

module SunspotHelpers
  def self.wait_until_solr_starts
    solr_started = false
    ping_uri = URI.parse("#{Sunspot.session.config.solr.url}/ping")
    150.times do
      begin
        Net::HTTP.get(ping_uri)
        solr_started = true
        break
      rescue
        sleep(0.1)
      end
    end
    raise "Solr failed to start after 15 seconds" unless solr_started
  end
end