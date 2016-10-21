# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  friend_id  :integer          indexed
#  user_id    :integer          indexed
#
# Indexes
#
#  index_friendships_on_friend_id  (friend_id)
#  index_friendships_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_e3733b59b7  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it { should belong_to(:user).with_foreign_key('user_id').class_name('User') }
  it do
    should belong_to(:friend)
      .with_foreign_key('friend_id')
      .class_name('User')
  end
end
