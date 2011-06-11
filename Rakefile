require 'rubygems'
require 'rake'

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

# require 'spec/rake/spectask'
# Spec::Rake::SpecTask.new(:spec) do |spec|
#   spec.libs << 'lib' << 'spec'
#   spec.spec_files = FileList['spec/**/*_spec.rb']
# end
# 
# Spec::Rake::SpecTask.new(:rcov) do |spec|
#   spec.libs << 'lib' << 'spec'
#   spec.pattern = 'spec/**/*_spec.rb'
#   spec.rcov = true
# end
# 
# begin
#   require 'cucumber/rake/task'
#   Cucumber::Rake::Task.new(:features)
# 
#   task :features => :check_dependencies
# rescue LoadError
#   task :features do
#     abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
#   end
# end
# 
# task :spec => :check_dependencies
# 
# task :default => :spec
# 
# require 'rake/rdoctask'
# Rake::RDocTask.new do |rdoc|
#   version = File.exist?('VERSION') ? File.read('VERSION') : ""
# 
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title = "sunspot_test #{version}"
#   rdoc.rdoc_files.include('README*')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
