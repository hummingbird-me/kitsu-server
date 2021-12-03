require 'rails_helper'

RSpec.describe Character, type: :model do
  it { should belong_to(:primary_media).optional }
  it { should have_many(:castings) }
  it { should have_many(:anime_characters).dependent(:destroy) }
  it { should have_many(:manga_characters).dependent(:destroy) }
  it { should have_many(:drama_characters).dependent(:destroy) }
end
