require 'pack_rat/cache_helper/cacher'
module PackRat
  module CacheHelper
    extend ActiveSupport::Concern

    included do
      extend Cacher
      include Cacher
      self.updated_attribute_name ||= :updated_at
      self.file_location = file_location_guesser
    end

    module ClassMethods
      def updated_attribute_name
        @updated_attribute_name
      end
      def updated_attribute_name=(name)
        @updated_attribute_name = name
      end
      def file_location
        @file_location
      end
      def file_location=(path)
        @file_location = path
      end
      # Create cache_key for class, use most recently updated record
      unless self.respond_to? :cache_key
        define_method :cache_key do
          key = order("#{self.updated_attribute_name} DESC").first.cache_key if self.superclass.to_s == "ActiveRecord::Base"
          key << "/#{self.to_s}"
        end
      end

      def file_digest
        if self.file_location
          begin
            file = File.read(self.file_location)
            @file_digst ||= MD5::Digest.hexdigest(file)
          rescue
            @file_digst = nil
          end
        end
      end
      
      def file_location_guesser
        "#{Rails.root}/app/models/#{self.to_s.split('::').join('/').underscore.downcase}.rb" if defined? Rails
      end
  
    end
  end
end