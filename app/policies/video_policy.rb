class VideoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      region = Thread.current[:region]
      return scope unless region.present? && region != 'XX'
      scope.available_in(region)
    end
  end
end
