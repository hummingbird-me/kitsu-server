class ModeratorActionLog < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :target, polymorphic: true, optional: false

  def self.generate!(actor, verb, target)
    create!(user: actor, verb: verb, target: target)
  end
end
