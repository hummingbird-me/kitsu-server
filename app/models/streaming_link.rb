# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: streaming_links
#
#  id          :integer          not null, primary key
#  dubs        :string           default(["\"ja\""]), not null, is an Array
#  media_type  :string           not null, indexed => [media_id]
#  subs        :string           default(["\"en\""]), not null, is an Array
#  url         :string           not null
#  created_at  :datetime
#  updated_at  :datetime
#  media_id    :integer          not null, indexed => [media_type]
#  streamer_id :integer          not null, indexed
#
# Indexes
#
#  index_streaming_links_on_media_type_and_media_id  (media_type,media_id)
#  index_streaming_links_on_streamer_id              (streamer_id)
#
# Foreign Keys
#
#  fk_rails_f92451e4ed  (streamer_id => streamers.id)
#
# rubocop:enable Metrics/LineLength

class StreamingLink < ApplicationRecord
  include Streamable

  belongs_to :media, polymorphic: true, touch: true, optional: false

  validates :media, :url, presence: true
  validates :media, polymorphism: { type: Media }
end
