# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: franchises
#
#  id              :integer          not null, primary key
#  canonical_title :string           default("en_jp"), not null
#  titles          :hstore           default({}), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# rubocop:enable Metrics/LineLength

class Franchise < ApplicationRecord
  include Titleable

  has_many :installments, dependent: :destroy

  enum progression_order: {
    release: 0,
    chronological: 1
  }
end
