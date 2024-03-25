# frozen_string_literal: true

module WithNewFeed
  extend ActiveSupport::Concern

  def new_feed
    NewFeed.find_by(id: feed_id)
  end

  included do
    before_validation do
      self.feed_id = NewFeed.create!.id if feed_id.nil?
    end

    validates :feed_id, presence: true
  end
end
