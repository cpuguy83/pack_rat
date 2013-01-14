module PackRat
  module CacheHelper
    module Cacher
      def cache(key='', options={}, &block)
        unless options[:overwrite_key] # if overwrite_key was set, we skip creating our own key
          calling_method = caller[0][/`([^']*)'/, 1] # Hack to get the method that called cache
          key << calling_method << '/'
          key << self.cache_key << '/'
          
          # Since this same method is used in both class and instance contexts, we need to check that here
          if self.is_a? Class
            key << self.file_digest
          else
            key << self.class.file_digest
          end
        end
        
        puts key if options[:debug] # Output the generated cache key to the console if debug is set
        filtered_options = options.except(:debug, :overwrite_key) # Remove PackRat related options so we can pass to Rails.cache
        
        # Make the actual Rails.cache call
        Rails.cache.fetch key, filtered_options do
          block.call
        end

      end
    end
  end
end