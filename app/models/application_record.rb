class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def stream_id
    "#{self.class.name}:#{self.id}"
  end

  def self.paperclip_definitions
    attachment_definitions
  end
end
