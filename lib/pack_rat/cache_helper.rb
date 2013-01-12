require 'pack_rat/cache_helper/cacher'
module PackRat
  module CacheHelper
    extend ActiveSupport::Concern

    included do
      extend Cacher
      include Cacher
      cattr_accessor :updated_attribute_name
      self.updated_attribute_name ||= :updated_at
      cattr_accessor :file_location
      self.file_location = file_location_guesser
      self.file_digest ||= Digest::MD5.hexdigest(self.file_location) if self.file_location
    end

    module ClassMethods    
      # Create cache_key for class, use most recently updated record
      unless self.respond_to? :cache_key
        define_method :cache_key do
          key = order("#{self.updated_attribute_name} DESC").first.cache_key if self.superclass.to_s == "ActiveRecord::Base"
          key << "/#{self.to_s}"
        end
      end

      #def file_digest
      #  if self.file_location
      #    begin
      #      file = File.read(self.file_location)
      #      @file_digst ||=
      #    rescue
      #      @file_digst = nil
      #    end
      #  end
      #end
      
      def file_location_guesser
        "#{Rails.root}/app/models/#{self.to_s.split('::').join('/').underscore.downcase}.rb" if defined? Rails
      end
  
    end
  end
end