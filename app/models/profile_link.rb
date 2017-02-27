# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: profile_links
#
#  id                   :integer          not null, primary key
#  url                  :string           not null
#  profile_link_site_id :integer          not null, indexed, indexed => [user_id]
#  user_id              :integer          not null, indexed, indexed => [profile_link_site_id]
#
# Indexes
#
#  index_profile_links_on_profile_link_site_id              (profile_link_site_id)
#  index_profile_links_on_user_id                           (user_id)
#  index_profile_links_on_user_id_and_profile_link_site_id  (user_id,profile_link_site_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_16f7039808  (profile_link_site_id => profile_link_sites.id)
#  fk_rails_740c28bcae  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class ProfileLink < ApplicationRecord
  has_paper_trail
  belongs_to :user, required: true
  belongs_to :profile_link_site, required: true

  validates :url, presence: true
  validate :url_formatted, if: :url

  before_validation do
    # updates the url to the expected output
    # Twitter, ie: toyhammered -> https://twitter.com/toyhammered
    self.url = url&.sub(
      profile_link_site.validate_find,
      profile_link_site.validate_replace
    )
  end

  def url_formatted
    errors.add(:url, 'is invalid') unless profile_link_site.validate_find =~ url
  end
end
