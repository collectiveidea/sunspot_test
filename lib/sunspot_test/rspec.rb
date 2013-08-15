require 'sunspot_test'

RSpec.configure do |c|
  c.before(:each) do
    SunspotTest.stub
  end
  
  c.before(:each, :search => true) do
    SunspotTest.setup_solr
    Sunspot.remove_all!
    Sunspot.commit
  end
end
