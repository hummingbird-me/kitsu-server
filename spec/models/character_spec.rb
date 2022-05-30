require 'rails_helper'

RSpec.describe Character, type: :model do
  it { is_expected.to belong_to(:primary_media).optional }
  it { is_expected.to have_many(:castings) }
  it { is_expected.to have_many(:anime_characters).dependent(:destroy) }
  it { is_expected.to have_many(:manga_characters).dependent(:destroy) }
  it { is_expected.to have_many(:drama_characters).dependent(:destroy) }
end
