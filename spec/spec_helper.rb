require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rspec'
require 'rspec/autorun'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'pack_rat'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

class TestClass
  include PackRat::CacheHelper
  self.file_location = '/dev/null'
  def some_method_with_cache
    cache do
      puts 'test'
    end
  end
  
  def some_method_without_cache
    puts 'test'
  end

  def cache_key
    'stuff'
  end
end

class Rails
  def self.cache
    Rails::Cache
  end
end

class Rails::Cache
  def self.fetch(*options, &block)
    block.call
  end
end