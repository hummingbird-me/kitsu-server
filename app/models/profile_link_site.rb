class ProfileLinkSite < ApplicationRecord
  validates :name, :validate_find, :validate_replace, presence: true

  def validate_find
    Regexp.new(self[:validate_find]) unless self[:validate_find].nil?
  end
end
