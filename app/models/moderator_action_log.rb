class ModeratorActionLog < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :target, polymorphic: true, required: true

  def self.generate!(actor, verb, target)
    create!(user: actor, verb: verb, target: target)
  end
end
