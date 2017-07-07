# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: amas
#
#  id                    :integer          not null, primary key
#  ama_subscribers_count :integer          default(0), not null
#  description           :string           not null
#  end_date              :datetime         not null
#  start_date            :datetime         not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  author_id             :integer          not null, indexed
#  original_post_id      :integer          not null, indexed
#
# Indexes
#
#  index_amas_on_author_id         (author_id)
#  index_amas_on_original_post_id  (original_post_id)
#
# Foreign Keys
#
#  fk_rails_be5e31a286  (author_id => users.id)
#  fk_rails_ef2f48b4b8  (original_post_id => posts.id)
#
# rubocop:enable Metrics/LineLength

class Ama < ApplicationRecord
  belongs_to :author, required: true, class_name: 'User'
  belongs_to :original_post, required: true, class_name: 'Post'
  has_many :posts, dependent: :destroy
  has_many :ama_subscribers, dependent: :destroy

  before_validation do
    self.end_date = start_date + 1.hour
  end
end
