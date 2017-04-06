# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_reports
#
#  id           :integer          not null, primary key
#  explanation  :text
#  naughty_type :string           not null, indexed => [naughty_id]
#  reason       :integer          not null
#  status       :integer          default(0), not null, indexed
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :integer          not null, indexed
#  moderator_id :integer
#  naughty_id   :integer          not null, indexed => [naughty_type]
#  user_id      :integer          not null, indexed
#
# Indexes
#
#  index_group_reports_on_group_id                     (group_id)
#  index_group_reports_on_naughty_type_and_naughty_id  (naughty_type,naughty_id)
#  index_group_reports_on_status                       (status)
#  index_group_reports_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_13d07d040e  (group_id => groups.id)
#  fk_rails_32fa0c6a2d  (moderator_id => users.id)
#  fk_rails_8abfbfa356  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe GroupReport, type: :model do
  subject { build(:group_report) }

  it { should define_enum_for(:reason) }
  it { should define_enum_for(:status) }
  it { should belong_to(:group) }
  it { should validate_presence_of(:group) }
  it { should belong_to(:naughty) }
  it { should validate_presence_of(:naughty) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:moderator).class_name('User') }
  it { should validate_presence_of(:reason) }
  it { should validate_presence_of(:status) }

  context 'with a reason of other' do
    subject { build(:group_report, reason: :other) }
    it { should validate_presence_of(:explanation) }
  end
end
