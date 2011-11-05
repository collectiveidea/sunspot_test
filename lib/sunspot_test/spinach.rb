require 'sunspot_test'

Spinach.hooks.before_scenario do
  SunspotTest.stub
end

Spinach.hooks.on_tag('search') do
  SunspotTest.setup_solr
  Sunspot.remove_all!
  Sunspot.commit
end