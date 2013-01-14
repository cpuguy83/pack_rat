module PackRat
  module Extensions
    module ActiveRecord
      def included(base)
        base.extend(ClassMethods)
      end
  
      module ClassMethods
        def inherited(child_class)
          child_class.send(:include, PackRat::CacheHelper)
          super
        end
      end

    end
  end
end

ActiveSupport.on_load :active_record do
  include PackRat::Extensions::ActiveRecord
end