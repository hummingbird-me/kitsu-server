class ConvertRankToPermissions < ActiveRecord::Migration
  class GroupMember < ActiveRecord::Base
    has_many :permissions, class_name: 'GroupPermission'
    enum rank: %i[pleb mod admin]
  end
  class GroupPermission < ActiveRecord::Base
    belongs_to :group_member, required: true
    enum permission: %i[owner tickets members leaders community content]
  end

  def up
    GroupMember.mod.each do |mod|
      mod.permissions.create!(permission: :community)
      mod.permissions.create!(permission: :content)
      mod.permissions.create!(permission: :members)
      mod.permissions.create!(permission: :tickets)
    end
    GroupMember.admin.each do |admin|
      admin.permissions.create(permission: :owner)
    end
  end
end
