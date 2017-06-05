# == Schema Information
#
# Table name: media_attribute_votes
#
#  id                 :integer          not null, primary key
#  media_type         :string           not null, indexed => [user_id, media_id, media_attribute_id]
#  vote               :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  anime_id           :integer          indexed
#  drama_id           :integer          indexed
#  manga_id           :integer          indexed
#  media_attribute_id :integer          not null, indexed, indexed => [user_id, media_id, media_type]
#  media_id           :integer          not null, indexed => [user_id, media_type, media_attribute_id]
#  user_id            :integer          not null, indexed, indexed => [media_id, media_type, media_attribute_id]
#
# Indexes
#
#  index_media_attribute_votes_on_anime_id            (anime_id)
#  index_media_attribute_votes_on_drama_id            (drama_id)
#  index_media_attribute_votes_on_manga_id            (manga_id)
#  index_media_attribute_votes_on_media_attribute_id  (media_attribute_id)
#  index_media_attribute_votes_on_user_id             (user_id)
#  index_user_media_attribute                         (user_id,media_id,media_type,media_attribute_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_39b0c09be9  (user_id => users.id)
#  fk_rails_49b7b50c01  (anime_id => anime.id)
#  fk_rails_6eca31c4de  (manga_id => manga.id)
#  fk_rails_ac232fc1fb  (drama_id => dramas.id)
#

FactoryGirl.define do
  factory :media_attribute_vote do
    vote 1
    user
    anime
    media_attribute
  end
end
