class Types::Input::Account::UpdateAccount < Types::Input::Base
  argument :name, String, required: false
  argument :slug, String, required: false
  argument :sfw_filter_preference, Types::Enum::SfwFilterPreference, required: false
end
