# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: amas
#
#  id                    :integer          not null, primary key
#  ama_subscribers_count :integer          default(0), not null
#  description           :string           not null
#  end_date              :datetime         not null
#  start_date            :datetime         not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  author_id             :integer          not null, indexed
#  original_post_id      :integer          not null, indexed
#
# Indexes
#
#  index_amas_on_author_id         (author_id)
#  index_amas_on_original_post_id  (original_post_id)
#
# Foreign Keys
#
#  fk_rails_be5e31a286  (author_id => users.id)
#  fk_rails_ef2f48b4b8  (original_post_id => posts.id)
#
# rubocop:enable Metrics/LineLength

class AMA < ApplicationRecord
  belongs_to :author, required: true, class_name: 'User'
  belongs_to :original_post, required: true, class_name: 'Post'
  has_many :ama_subscribers, dependent: :destroy

  scope :for_original_post, ->(post) { where(original_post: post) }
  scope :past_ama, -> { where('end_date < ?', Date.today) }
  scope :future_ama, -> { where('end_date >= ?', Date.today) }

  def feed
    @feed ||= AMAFeed.new(id)
  end

  def send_ama_notification
    feed.activities.new(
      target: original_post,
      actor: author,
      object: self,
      foreign_id: self,
      verb: self.class.name.underscore,
      time: Time.now
    ).create
  end

  def open?
    (start_date..end_date).cover?(Time.now)
  end

  before_validation do
    self.end_date = start_date + 1.hour if end_date.blank? || start_date >= end_date
  end

  after_commit do
    ama_starting_soon_time = start_date - 1.hour
    AMAStartingWorker.perform_at(ama_starting_soon_time, self)
  end
end
