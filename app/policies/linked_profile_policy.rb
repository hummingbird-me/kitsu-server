class LinkedProfilePolicy < ApplicationPolicy
  def update?
    record.user == user || is_admin?
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?

  class Scope < Scope
    def resolve
      return scope.where(private: false) unless user
      t = LinkedProfile.arel_table
      private, user_id = t[:private], t[:user_id]

      # Don't apply privacy if user is admin
      return scope if is_admin?
      # RAILS-5: This can be replaced with a simple ActiveRecord.or
      # (private == true && user == owner) || private == false
      scope.where(
        private.eq(false).or(
          user_id.eq(user.id).and(private.eq(true))
        )
      )
    end
  end
end
