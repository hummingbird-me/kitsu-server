class Types::Input::Account::Update < Types::Input::Base
  argument :about, String, required: false
  argument :name, String, required: false
  argument :waifu_or_husbando, Types::Enum::WaifuOrHusbando, required: false
  argument :waifu_id, ID, required: false
  argument :gender, String, required: false
  argument :birthday, Types::Date, required: false
  argument :slug, String, required: false
  argument :sfw_filter_preference, Types::Enum::SfwFilterPreference, required: false
end