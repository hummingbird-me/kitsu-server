module Sluggable
  extend ActiveSupport::Concern

  included do
    extend FriendlyId
  end

  class_methods do
    # HACK: we need to return a relation but want to handle historical slugs
    def by_slug(slug)
      record = where(slug: slug)
      record = where(id: friendly.find(slug).id) if record.empty?
      record
    rescue
      none
    end
  end
end
