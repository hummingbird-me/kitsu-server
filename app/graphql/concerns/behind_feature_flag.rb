module BehindFeatureFlag
  extend ActiveSupport::Concern

  class_methods do
    def behind_feature_flag(flag)
      if method_defined?(:visible?)
        define_method(:visible?) do |context|
          super(context) && Flipper[flag].enabled?(context[:user])
        end
      elsif respond_to?(:visible?)
        define_singleton_method(:visible?) do |context|
          super(context) && Flipper[flag].enabled?(context[:user])
        end
      else
        ref = self&.name || self.class&.name
        raise ArgumentError, "Cannot put #{ref} behind a feature flag"
      end
    end
  end
end
