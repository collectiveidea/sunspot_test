require 'sunspot_test'

RSpec.configure do |c|
  c.before(:all) do
    SunspotTest.stub
  end
  
  c.before(:all, :search => true) do
    SunspotTest.setup_solr
    Sunspot.remove_all!
    Sunspot.commit
  end
end