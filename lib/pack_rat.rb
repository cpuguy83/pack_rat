require 'active_support'
require 'pack_rat/active_record_extension'
require 'pack_rat/cache_helper'
if defined? ActiveRecord::Base
  ActiveRecord::Base.send(:include, PackRat::ActiveRecordExtension)
end
  
  
  