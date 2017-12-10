module Sluggable
  extend ActiveSupport::Concern

  included do
    extend FriendlyId

    before_save do
      # Force to nil
      self.slug = nil if slug.blank?
    end
  end

  class_methods do
    # HACK: we need to return a relation but want to handle historical slugs
    def by_slug(slug)
      record = where(slug: slug)
      return record if record.present?

      value = slug.is_a?(Array) ? slug.first : slug
      where(id: friendly.find(value).id)
    rescue
      none
    end
  end
end
