module LocalizableModel
  extend ActiveSupport::Concern

  class_methods do
    def localized_attr(name)
      name = name.to_s

      validate do
        if attributes[name].keys.any? { |k| k.start_with?('en') }
          errors.add(name, 'must have at least one English entry')
        end
      end
    end
  end
end
