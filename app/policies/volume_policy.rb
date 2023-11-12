# frozen_string_literal: true

class VolumePolicy < ApplicationPolicy
  administrated_by :database_mod
end
