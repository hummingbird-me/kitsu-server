module StreamDump
  class Story < ActiveRecord::Base
    default_scope { where(deleted_at: nil) }

    has_many :substories
    belongs_to :library_entry
  end
end
