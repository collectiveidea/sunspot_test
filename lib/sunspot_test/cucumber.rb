require 'sunspot_test'

Before("@searchrunning") do
  $sunspot = true
end

# Old-style tag expressions were deprecated in cucumber 3.0.0.pre.2, and removed in 4.0.0.rc.1:
# https://github.com/cucumber/cucumber-ruby/blob/master/CHANGELOG.md#300pre2
# https://github.com/cucumber/cucumber-ruby/blob/master/CHANGELOG.md#400rc1-2018-09-29
negated_tag_prefix =
  if defined?(Cucumber::VERSION) && Gem::Version.new(Cucumber::VERSION) >= Gem::Version.new('3')
    "not "
  else
    "~"
  end

Before("#{negated_tag_prefix}@search") do
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
