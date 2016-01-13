# encoding: utf-8
#
Gem::Specification.new do |s|
  s.name = "sunspot_test"
  s.version = "0.4.0"

  s.authors = ["Zach Moazeni"]
  s.email = "zach@collectiveidea.com"
  s.description = "Testing sunspot with cucumber can be a pain. This gem will automatically start/stop solr with cucumber scenarios tagged with @search"
  s.summary = "Auto-starts solr for your cucumber tests"
  s.homepage = "https://github.com/collectiveidea/sunspot_test"
  s.license = "MIT"

  s.files = `git ls-files`.split($/)
  s.test_files = s.files.grep(/^spec/)
  s.require_paths = ["lib"]

  s.add_runtime_dependency "sunspot_rails", ">= 1.2.1"

  s.add_development_dependency "bundler", "~> 1.5"
  s.add_development_dependency "rake", "~>10.1"
  s.add_development_dependency "rspec", "~> 2.14"
end

