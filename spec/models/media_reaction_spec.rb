# == Schema Information
#
# Table name: media_reactions
#
#  id               :integer          not null, primary key
#  media_type       :string           not null, indexed => [media_id, user_id]
#  progress         :integer          default(0), not null
#  reaction         :string(140)
#  up_votes_count   :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  library_entry_id :integer          indexed
#  media_id         :integer          not null, indexed => [media_type, user_id]
#  user_id          :integer          indexed => [media_type, media_id], indexed
#
# Indexes
#
#  index_media_reactions_on_library_entry_id                     (library_entry_id)
#  index_media_reactions_on_media_type_and_media_id_and_user_id  (media_type,media_id,user_id) UNIQUE
#  index_media_reactions_on_user_id                              (user_id)
#
# Foreign Keys
#
#  fk_rails_08b3ced6d4  (user_id => users.id)
#  fk_rails_bbc29d526d  (library_entry_id => library_entries.id)
#

require 'rails_helper'

RSpec.describe MediaReaction, type: :model do
  subject { build(:media_reaction) }

  it { should belong_to(:media) }
  it { should belong_to(:user) }
  it { should belong_to(:library_entry)}
end
