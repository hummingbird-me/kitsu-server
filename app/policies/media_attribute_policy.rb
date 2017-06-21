class MediaAttributePolicy < ApplicationPolicy
  def create?
    false
  end
  alias_method :update?, :create?
  alias_method :destroy?, :create?
end
