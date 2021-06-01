class WikiSubmissionPolicy < ApplicationPolicy
  administrated_by :community_mod

  alias_method :create_draft?, :is_owner?
  alias_method :update_draft?, :is_owner?
  alias_method :submit_draft?, :is_owner?
end
