class ProfileLinkSite < ApplicationRecord
  validates_presence_of :name, :validate_find, :validate_replace

  def validate_find
    Regexp.new(self[:validate_find]) unless self[:validate_find].nil?
  end
end
