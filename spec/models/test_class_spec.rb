require 'spec_helper'

describe TestClass do
  it 'should respond to cache_key' do
    TestClass.cache_key
  end
  it 'should return the same values with or without cache' do
    test = TestClass.new
    test.some_method_with_cache.should == test.some_method_without_cache
  end
end