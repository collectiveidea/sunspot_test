require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sunspot_test"
    gem.summary = %Q{Auto-starts solr for your cucumber tests}
    gem.description = %Q{Testing sunspot with cucumber can be a pain. This gem will automatically start/stop solr with cucumber scenarios tagged with @search}
    gem.email = "zach@collectiveidea.com"
    gem.homepage = "https://github.com/collectiveidea/sunspot_test"
    gem.authors = ["Zach Moazeni"]
    gem.add_dependency "sunspot_rails", ">= 1.2.1"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

task :default => :spec
