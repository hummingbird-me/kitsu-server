class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def stream_id
    "#{self.class.name}:#{self.id}"
  end
end
