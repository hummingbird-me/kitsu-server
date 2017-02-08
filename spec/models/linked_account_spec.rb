# == Schema Information
#
# Table name: linked_accounts
#
#  id                 :integer          not null, primary key
#  encrypted_token    :string
#  encrypted_token_iv :string
#  share_from         :boolean          default(FALSE), not null
#  share_to           :boolean          default(FALSE), not null
#  sync_to            :boolean          default(FALSE), not null
#  type               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  external_user_id   :string           not null
#  user_id            :integer          not null, indexed
#
# Indexes
#
#  index_linked_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_166e103170  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe LinkedAccount, type: :model do
  subject { described_class.new }

  it { should belong_to(:user) }
  it { should validate_presence_of(:external_user_id) }
  it { should validate_presence_of(:type) }
end
