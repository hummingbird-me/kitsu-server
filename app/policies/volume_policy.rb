class VolumePolicy < ApplicationPolicy
  def create?
    is_admin?
  end
  alias_method :destroy?, :create?
  alias_method :update?, :create?
end
