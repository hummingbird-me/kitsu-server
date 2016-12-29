# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: reports
#
#  id           :integer          not null, primary key
#  explanation  :text
#  naughty_type :string           not null, indexed => [naughty_id]
#  reason       :integer          not null
#  status       :integer          default(0), not null, indexed
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  moderator_id :integer
#  naughty_id   :integer          not null, indexed => [user_id], indexed => [naughty_type]
#  user_id      :integer          not null, indexed => [naughty_id]
#
# Indexes
#
#  index_reports_on_naughty_id_and_user_id       (naughty_id,user_id) UNIQUE
#  index_reports_on_naughty_type_and_naughty_id  (naughty_type,naughty_id)
#  index_reports_on_status                       (status)
#
# Foreign Keys
#
#  fk_rails_c7699d537d  (user_id => users.id)
#  fk_rails_cfe003e081  (moderator_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Report, type: :model do
  subject { build(:report) }

  it { should define_enum_for(:reason).with(%i[nsfw offensive spoiler bullying
                                                other spam]) }
  it { should define_enum_for(:status).with(%i[reported resolved declined]) }
  it { should belong_to(:naughty) }
  it { should validate_presence_of(:naughty) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:moderator).class_name('User') }
  it { should validate_presence_of(:reason) }
  it { should validate_presence_of(:status) }

  context 'with a reason of other' do
    subject { build(:report, reason: :other) }
    it { should validate_presence_of(:explanation) }
  end
end
