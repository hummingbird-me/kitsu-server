# frozen_string_literal: true

class UnitInMediaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless value.media_type == record.media_type && value.media_id == record.media_id
      record.errors.add(attribute, "must be from the tagged media")
    end
  end
end