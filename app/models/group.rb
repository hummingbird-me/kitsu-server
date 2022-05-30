class Group < ApplicationRecord
  include AvatarUploader::Attachment(:avatar)
  include CoverImageUploader::Attachment(:cover_image)
  include ContentProcessable
  include Sluggable

  friendly_id :name, use: %i[slugged finders history]
  processable :rules, RulesPipeline
  enum privacy: { open: 0, closed: 1, restricted: 2 }

  update_index('groups#group') { self }
  update_index('users#group_member') { members }
  update_algolia('AlgoliaGroupsIndex')

  scope :public_visible, -> { open.or(restricted) }
  scope :sfw, -> { where(nsfw: false).where.not(category_id: 9) }
  scope :visible_for, ->(user) {
    # private == false || is a member
    return public_visible unless user
    members = user.group_members.select(:group_id)
    where(id: members).or(public_visible)
  }

  has_many :members, class_name: 'GroupMember', dependent: :destroy
  has_many :owners, -> { admin }, class_name: 'GroupMember'
  has_many :neighbors, class_name: 'GroupNeighbor', dependent: :destroy,
    foreign_key: 'source_id'
  has_many :tickets, class_name: 'GroupTicket', dependent: :destroy
  has_many :invites, class_name: 'GroupInvite', dependent: :destroy
  has_many :reports, class_name: 'GroupReport', dependent: :destroy
  has_many :leader_chat_messages, dependent: :destroy
  has_many :bans, class_name: 'GroupBan', dependent: :destroy
  has_many :action_logs, class_name: 'GroupActionLog', dependent: :destroy
  belongs_to :category, class_name: 'GroupCategory', optional: false
  belongs_to :pinned_post, class_name: 'Post', optional: true

  validates :name, presence: true,
    length: { in: 3..50 },
    uniqueness: { case_sensitive: false }
  validates :tagline, length: { maximum: 60 }, allow_blank: true
  validates :privacy, inclusion: {
    in: %w[closed],
    message: 'cannot open a closed group'
  }, if: ->(g) { g.privacy_was == 'closed' }
  validates :about, length: { maximum: 9_000 }, allow_blank: true
  validates :rules, length: { maximum: 9_000 }, allow_blank: true

  def member_for(user)
    members.where(user: user).first
  end

  def public_visible?
    open? || restricted?
  end

  def feed
    GroupFeed.new(id)
  end

  # @return [Group,nil] the Kitsu group, if one exists
  def self.kitsu
    @kitsu ||= find_by(id: 1830)
  end

  before_validation do
    self.nsfw = category_id == 9 if category_id_changed?
    true
  end

  # Not bothering with teardown because the group ID won't be reused (so who
  # cares?)
  after_commit(on: :create) do
    feed.setup!
  end
end
