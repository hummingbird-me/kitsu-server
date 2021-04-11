class WikiSubmissionPolicy < ApplicationPolicy
  administrated_by :community_mod

  def create_draft?
    true
  end

  def update_draft?
    true
  end

  def submit_draft?
    true
  end
end
