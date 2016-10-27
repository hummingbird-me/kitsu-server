# == Schema Information
#
# Table name: linked_profiles
#
#  id               :integer          not null, primary key
#  public           :boolean          default(FALSE), not null
#  share_from       :boolean          default(FALSE), not null
#  share_to         :boolean          default(FALSE), not null
#  token            :string
#  url              :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  external_user_id :string           not null
#  linked_site_id   :integer          not null, indexed
#  user_id          :integer          not null, indexed
#
# Indexes
#
#  index_linked_profiles_on_linked_site_id  (linked_site_id)
#  index_linked_profiles_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_166e103170  (user_id => users.id)
#  fk_rails_25de88e967  (linked_site_id => linked_sites.id)
#

require 'rails_helper'

RSpec.describe LinkedProfile, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:linked_site) }

  subject { described_class.new }

  describe 'validates url' do
    context 'if public' do
      before { allow(subject).to receive(:public?).and_return(true) }
      it { should validate_presence_of(:url) }
    end
    context 'if private' do
      before { allow(subject).to receive(:public?).and_return(false) }
      it { should_not validate_presence_of(:url) }
    end
  end
end
