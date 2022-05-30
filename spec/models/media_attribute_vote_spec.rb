require 'rails_helper'

RSpec.describe MediaAttributeVote, type: :model do
  subject { build(:media_attribute_vote) }

  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:anime_media_attributes).optional }
  it { is_expected.to belong_to(:dramas_media_attributes).optional }
  it { is_expected.to belong_to(:manga_media_attributes).optional }
end
