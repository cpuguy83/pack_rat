# PackRat

PackRat is a simple helper for Rails.cache<br />
When included in your class it makes caching trivial.

    class MyClass
      include PackRat::CacheHelper
    
      def some_method
        cache do
          #stuff
        end
      end
      
      def self.some_class_method
        cache do
          # stuff
        end
      end
    end

## Installation
To install:

    gem install pack_rat

or include in your Gemfile

    gem 'pack_rat'

PackRat::CacheHelper does a few things:

* Adds a cache\_key method to your class, which takes your most recently updated record (assuming a model here) and calls it's cache\_key, and adds your classes name<br />
  Right now cache_key assumes you are using ActiveRecord as your ORM, but you can overwrite this
* Adds a few of class attrs:
  * file\_location - Defaults to using your model's name to determine the file's path, you can set this manually in your class `self.file_location = '/path/to/file'`
  * updated\_attribute\_name - Defaults to :updated_at, this is used for your class's cache\_key method, `self.updated_attribute_name = :my_custom_attr`
  * file\_digest - When your class is first loaded an MD5 digest is created, based on file\_location, this ensures that if your class changes, your caches automatically expire
* Adds a `cache` method to your class and your instances<br />
  `cache` uses the calling method name, your class's md5 digest, and the calling context's cache\_key method<br />
  You can pass in some options:
    * overwrite\_key - When set, whatever key is passed into `cache` will overwrite the automatically generated key<br />
      If a key is provided and overwrite_key is not set, it will get added to the auto generated key
    * debug - When set, will output the generated cache key to the console
    * accepts all other options available to <a href="https://www.google.com/url?url=http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html%23method-i-fetch&rct=j&q=Rails.cache.fetch&usg=AFQjCNGCOKoKf1oOCJpQsURoQfG6jNYgsw&sa=X&ei=PXDxUMCPBYz69gSP4IHwDQ&ved=0CDcQygQwAA">Rails.cache.fetch</a>

When included into your gemfile, PackRat is automatically included into ActiveRecord::Base

If you do not want an MD5 digest created, then set `self.file_location = nil` in your class.

Check it out. Use the `debug: true` option in your cache call to see what key is actually being generated for debugging
    
    def some_method
      cache '', debug: true do
        # stuff
      end
    end

An Example using an ActiveRecord class

    class MyClass < ActiveRecord::Base
      
      def my_long_instance_method
        cache do
          puts 'stuff'
        end
      end
      
      def self.my_long_class_method
        cache do
          puts 'stuff'
        end
      end
      
      def method_with_debug
        cache [], debug: true do
          puts 'stuff'
        end
      end
      
      def self.class_method_with_debug
        cache [], debug: true do
          puts 'stuff'
        end
      end
    end

### If you are passing in options, you must specify a cache key, this can be an empty string, or an empty array, or even not empty, but it has to be there


## Contributing to pack_rat
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Brian Goff. See LICENSE.txt for
further details.

