module PackRat
  module ActiveRecordExtension
    extend ActiveSupport::Concern
  
    module ClassMethods
      def inherited(child_class)
        child_class.send(:include, PackRat::CacheHelper)
        super
      end
    end
  end
end