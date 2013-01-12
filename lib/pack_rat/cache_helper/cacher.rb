module PackRat
  module CacheHelper
    module Cacher
      def cache(key='', options={}, &block)
        unless options[:overwrite_key]
          calling_method = caller[0][/`([^']*)'/, 1]
          key << calling_method << '/'
          key << self.cache_key << '/'
          if self.is_a? Class
            key << self.file_digest
          else
            key << self.class.file_digest
          end
        end
        puts key if options[:debug]
        filtered_options = options.dup
        filtered_options.delete(:debug)
        filtered_options.delete(:overwrite_key)
        Rails.cache.fetch key, filtered_options do
          block.call
        end
      end
    end
  end
end