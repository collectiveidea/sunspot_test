# SunspotTest
[![Gem Version](https://badge.fury.io/rb/sunspot_test.png)](http://badge.fury.io/rb/sunspot_test)
[![Build Status](https://travis-ci.org/collectiveidea/sunspot_test.svg?branch=master)](https://travis-ci.org/collectiveidea/sunspot_test)
[![Code Climate](https://codeclimate.com/github/collectiveidea/sunspot_test.png)](https://codeclimate.com/github/collectiveidea/sunspot_test)
[![Coverage Status](https://codeclimate.com/github/collectiveidea/sunspot_test/coverage.png)](https://codeclimate.com/github/collectiveidea/sunspot_test/coverage.png)
[![Dependency Status](https://gemnasium.com/collectiveidea/sunspot_test.svg)](https://gemnasium.com/collectiveidea/sunspot_test)

## How to install

Install this sunspot_test from rubygems either directly:

```bash
gem install sunspot_test
```

Or through bundler

```ruby
# in Gemfile
gem "sunspot_test"
```

Then in Cucumber's env.rb:

```ruby
require 'sunspot_test/cucumber'
```

## What does it do?

This gem will automatically start and stop solr for cucumber tests when using the @search tag. For instance, if you have a searchable book model this will allow you to create/query/destroy books.

```
@search
Feature: Books

  Scenario: Searching for a book
    Given a book exists with a title of "Of Mice and Men"
```

If your feature is not tagged with @search the environment will use a sunspot test proxy object which will silently swallow all requests.

Starting solr will depend on your settings in `config/sunspot.yml` (though this configuration file is optional). If you run into issues remember to look for existing java processes, starting solr may conflict with existing instances. You can also check out http://collectiveidea.com/blog/archives/2011/05/25/testing-with-sunspot-and-cucumber/ which contains a little more information.

## Can it do RSpec?

In `spec_helper.rb`

```
require 'sunspot_test/rspec'
```

Then within your specs, you'll need to tag and explicitly commit changes to solr:

```ruby
require 'spec_helper'

describe "searching", :search => true do
  it 'returns book results' do
    book = Factory(:book, :title => "Of Mice and Men")
    Sunspot.commit
    Book.search { keywords "mice"}.results.should == [book]
  end
end
```

## Can it do TestUnit?

Same as RSpec.

In `test_helper.rb`

```ruby
require 'sunspot_test/test_unit'
```

Then within your test, you'll need to tag and explicitly commit changes to solr:

```ruby
test 'searching' do
  book = Factory(:book, :title => "Of Mice and Men")
  Sunspot.commit
  assert_equal [book], Book.search { keywords "mice"}.results
end
```

## Configuring the timeout

The test suite will try and launch a solr process and wait for 15 seconds for the process to launch. You can configure this timeout by setting the following in env.rb:

```ruby
SunspotTest.solr_startup_timeout = 60 # will wait 60 seconds for the solr process to start
```

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Zach Moazeni. See LICENSE for details.
