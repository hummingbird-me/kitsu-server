class AMA < ApplicationRecord
  include DescriptionSanitation

  belongs_to :author, optional: false, class_name: 'User'
  belongs_to :original_post, optional: false, class_name: 'Post'
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
