class WikiSubmissionPolicy < ApplicationPolicy
  administrated_by :community_mod

  def create_draft?
    true
  end

  def approve_draft?
    true
  end
end
