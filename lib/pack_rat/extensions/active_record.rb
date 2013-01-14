module PackRat
  module Extensions
    module ActiveRecord
      
      # When AR::Base is inherited, incude PackRat into inheriting class
      def inherited(child_class)
        child_class.send(:include, PackRat::CacheHelper)
        super
      end
    end
  end
end

# Lazy load AR Extension into AR if ActiveSupport is there
if defined? ActiveSupport
  ActiveSupport.on_load :active_record do
    extend PackRat::Extensions::ActiveRecord
  end
else
  # Load immediately if no ActiveSupport loaded
  ActiveRecord::Base.send(:extend, PackRat::Extensions::ActiveRecord) if defined? ActiveRecord::Base
end