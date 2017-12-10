# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: streamers
#
#  id                    :integer          not null, primary key
#  logo_content_type     :string
#  logo_file_name        :string
#  logo_file_size        :integer
#  logo_updated_at       :datetime
#  site_name             :string(255)      not null
#  streaming_links_count :integer          default(0), not null
#  created_at            :datetime
#  updated_at            :datetime
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :streamer do
    site_name { Faker::Company.name }
    logo { Faker::Company.logo }
  end
end
