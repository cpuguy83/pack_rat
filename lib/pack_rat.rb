module PackRat
  module CacheHelper
    extend ActiveSupport::Concern

    included do
      extend Cacher
      include Cacher
      cattr_accessor :updated_attribute_name
      self.updated_attribute_name ||= :updated_at
      cattr_accessor :file_location
      cattr_accessor :file_digest
      self.file_location ||= "#{Rails.root}/app/models/#{self.to_s.split('::').join('/').underscore.downcase}.rb" if defined? Rails
      self.file_digest ||= Digest::MD5.hexdigest(File.read(self.file_location)) if self.file_location && self.file_location !~ /active_record\/base\.rb/
    end

    module Cacher
      def cache(key='', options={}, &block)
        unless options[:overwrite_key]
          calling_method = caller[0][/`([^']*)'/, 1]
          key << calling_method << '/'
          key << self.cache_key << '/'
          key << self.file_digest
        end
        puts key if options[:debug]
        filtered_options = options.except(:overwrite_key, :debug)
        Rails.cache.fetch key, filtered_options do
          block.call
        end
      end
    end

    module ClassMethods    
      # Create cache_key for class, use most recently updated record
      unless self.respond_to? :cache_key
        define_method :cache_key do
          key = order("#{self.updated_attribute_name} DESC").first.cache_key if self.superclass.to_s == "ActiveRecord::Base"
          key << "/#{self.to_s}"
        end
      end
    end
  end
end
ActiveRecord::Base.send(:include, PackRat::CacheHelper) if defined? ActiveRecord::Base