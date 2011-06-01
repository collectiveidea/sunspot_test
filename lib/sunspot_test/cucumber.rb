require 'sunspot_test'

Before("@searchrunning") do
  $sunspot = true
end

Before("~@search") do
  SunspotTest.stub
end

Before("@search") do
  SunspotTest.setup_solr
  Sunspot.remove_all!
  Sunspot.commit
end

AfterStep('@search') do
  Sunspot.commit
end
