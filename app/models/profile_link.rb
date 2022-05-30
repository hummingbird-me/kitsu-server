class ProfileLink < ApplicationRecord
  belongs_to :user
  belongs_to :profile_link_site

  validates :url, presence: true
  validate :url_formatted, if: -> { profile_link_site.present? && url.present? }

  before_validation if: -> { profile_link_site.present? && url.present? } do
    # updates the url to the expected output
    # Twitter, ie: toyhammered -> https://twitter.com/toyhammered
    self.url = url.sub(
      profile_link_site.validate_find,
      profile_link_site.validate_replace
    )
  end

  def url_formatted
    errors.add(:url, 'is invalid') unless profile_link_site.validate_find&.match?(url)
  end
end
