class Types::Enum::FeatureFlag < Types::Enum::Base
  Flipper.preload_all.each do |feature|
    value feature.name.upcase, feature.name.titleize, value: feature.name
  end
end
