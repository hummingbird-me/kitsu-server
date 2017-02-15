# == Schema Information
#
# Table name: groups
#
#  id                       :integer          not null, primary key
#  about                    :text             default(""), not null
#  avatar_content_type      :string(255)
#  avatar_file_name         :string(255)
#  avatar_file_size         :integer
#  avatar_processing        :boolean          default(FALSE), not null
#  avatar_updated_at        :datetime
#  cover_image_content_type :string(255)
#  cover_image_file_name    :string(255)
#  cover_image_file_size    :integer
#  cover_image_updated_at   :datetime
#  locale                   :string
#  members_count            :integer          default(0)
#  name                     :string(255)      not null
#  nsfw                     :boolean          default(FALSE), not null
#  privacy                  :integer          default(0), not null
#  rules                    :text
#  rules_formatted          :text
#  slug                     :string(255)      not null, indexed
#  tags                     :string           default([]), not null, is an Array
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_groups_on_slug  (slug) UNIQUE
#

class Group < ApplicationRecord
  include WithAvatar
  include WithCoverImage
  include ContentProcessable
  include Sluggable

  friendly_id :name, use: %i[slugged finders history]
  processable :rules, RulesPipeline
  enum privacy: %i[open closed restricted]
  scope :sfw, ->() { where(nsfw: false) }

  has_many :members, class_name: 'GroupMember', dependent: :destroy
  has_many :owners, ->() { admin }, class_name: 'GroupMember'

  validates :name, presence: true, length: { in: 4..50 }
  validates :owners, length: { minimum: 1 }

  def member_for(user)
    members.where(user: user)
  end

  def feed
    Feed.group(id)
  end

  def aggregated_feed
    Feed.group_aggr(id)
  end
end
