class LibraryEntryPolicy < ApplicationPolicy
  alias_method :update?, :is_owner?
  alias_method :create?, :is_owner?
  alias_method :destroy?, :is_owner?

  class Scope < Scope
    def resolve
      return scope.where(private: false) unless user
      t = LibraryEntry.arel_table
      private, user_id = t[:private], t[:user_id]

      filtered_scope = scope
      # Apply SFW filter if it's enabled
      filtered_scope = filtered_scope.sfw if user&.sfw_filter?
      # Don't apply privacy if the user is an admin
      return filtered_scope if user.has_role?(:admin)
      # RAILS-5: This can be replaced with a simple ActiveRecord.or
      # (private == true && user == owner) || private == false
      filtered_scope.where(
        private.eq(false).or(
          user_id.eq(user.id).and(private.eq(true))
        )
      )
    end
  end
end
