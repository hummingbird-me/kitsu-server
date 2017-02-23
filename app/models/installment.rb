# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: installments
#
#  id           :integer          not null, primary key
#  media_type   :string           not null, indexed => [media_id]
#  position     :integer          default(0), not null
#  tag          :string
#  franchise_id :integer          indexed
#  media_id     :integer          indexed => [media_type]
#
# Indexes
#
#  index_installments_on_franchise_id             (franchise_id)
#  index_installments_on_media_type_and_media_id  (media_type,media_id)
#
# rubocop:enable Metrics/LineLength

class Installment < ApplicationRecord
  has_paper_trail
  acts_as_list

  validates :tag, length: { maximum: 40 }
  validates :media, polymorphism: { type: Media }

  belongs_to :franchise, required: true
  belongs_to :media, polymorphic: true, required: true
end
