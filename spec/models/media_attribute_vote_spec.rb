require 'rails_helper'

RSpec.describe MediaAttributeVote, type: :model do
  subject { build(:media_attribute_vote) }

  it { should belong_to(:user).required }
  it { should belong_to(:anime_media_attributes).optional }
  it { should belong_to(:dramas_media_attributes).optional }
  it { should belong_to(:manga_media_attributes).optional }
end
