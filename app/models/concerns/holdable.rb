# frozen_string_literal: true

# Allows a record to be held for manual moderator approval.
module Holdable
  extend ActiveSupport::Concern

  included do
    enum :held_reason, { spamfilter: 1, wordfilter: 2 }

    scope :not_held, -> { where(held_reason: nil) }
    scope :held, -> { where.not(held_reason: nil) }
  end
end
