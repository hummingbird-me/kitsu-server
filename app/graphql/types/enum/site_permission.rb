class Types::Enum::SitePermission < Types::Enum::Base
  value 'ADMIN', 'Administrator/staff member of Kitsu', value: 'admin'
  value 'COMMUNITY_MOD', 'Moderator of community behavior', value: 'community_mod'
  value 'DATABASE_MOD', 'Maintainer of the Kitsu media database', value: 'database_mod'
end
