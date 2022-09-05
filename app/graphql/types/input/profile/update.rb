class Types::Input::Profile::Update < Types::Input::Base
  argument :id, ID, required: false
  argument :about, String, required: false
  argument :waifu_or_husbando, Types::Enum::WaifuOrHusbando, required: false
  argument :waifu_id, ID, required: false
  argument :gender, String, required: false
  argument :birthday, Types::Date, required: false
end