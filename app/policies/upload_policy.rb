class UploadPolicy < ApplicationPolicy
  def destroy?
    false
  end
end
