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

  validates_presence_of :url, if: :private?
  validates_presence_of :external_user_id

  before_save do
    # Check to make sure username/password is valid
    # I don't know how to test/check this is actually valid,
    # but it should work
    # host = MyAnimeListSyncService::ATARASHII_API_HOST
    # request = Typhoeus::Request.new(
    #   "#{host}account/verify_credentials",
    #   method: :get,
    #   userpwd: "#{external_user_id}:#{token}"
    # ).run
    #
    # # should be a 403 I think if it fails
    # return false if request.response.code != 200
    #
    # true
  end

  after_save do
    if url == 'myanimelist'
      MyAnimeListListComparisonWorker.perform_async(user_id)
    end
  end
end
