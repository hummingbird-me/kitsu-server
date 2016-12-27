# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: linked_profiles
#
#  id               :integer          not null, primary key
#  private          :boolean          default(TRUE), not null
#  share_from       :boolean          default(FALSE), not null
#  share_to         :boolean          default(FALSE), not null
#  token            :string
#  url              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  external_user_id :string           not null
#  linked_site_id   :integer          not null, indexed
#  user_id          :integer          not null, indexed
#
# Indexes
#
#  index_linked_profiles_on_linked_site_id  (linked_site_id)
#  index_linked_profiles_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_166e103170  (user_id => users.id)
#  fk_rails_25de88e967  (linked_site_id => linked_sites.id)
#
# rubocop:enable Metrics/LineLength

class LinkedProfile < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :linked_site, required: true

  attr_encrypted :token, key: ENV['LP_TOKEN_KEY']

  validates_presence_of :url, if: :private?
  validates_presence_of :external_user_id
  validate :verify_mal_credentials

  def verify_mal_credentials
    # Check to make sure username/password is valid

    # host = MyAnimeListSyncService::ATARASHII_API_HOST
    # request = Typhoeus::Request.new(
    #   "#{host}account/verify_credentials",
    #   method: :get,
    #   userpwd: "#{external_user_id}:#{token}"
    # )
    # request.run

    # response = request.response

    # if response.code != 200
    #   errors.add(:token, "#{response.code}: #{response.body}")
    # end

    # true
  end

  after_save do
    if url == 'myanimelist'
      MyAnimeListListComparisonWorker.perform_async(user_id)
    end
  end
end
