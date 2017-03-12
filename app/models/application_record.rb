class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def stream_id
    "#{self.class.name}:#{self.id}"
  end

  def self.paperclip_definitions
    attachment_definitions
  end

  def self.created_today
    where(created_at: Date.today..Date.tomorrow)
  end
end
