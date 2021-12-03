require 'rails_helper'

RSpec.describe SiteAnnouncement, type: :model do
  it { should belong_to(:user).required }
  it { should validate_presence_of(:title) }
end
