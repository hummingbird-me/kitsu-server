require 'rails_helper'

RSpec.describe SiteAnnouncementView, type: :model do
  describe '#seen?' do
    it 'should return false if the seen_at is blank' do
      model = build(:site_announcement_view, seen_at: nil)
      expect(model.seen?).to eq(false)
    end

    it 'should return true if the seen_at is set' do
      model = build(:site_announcement_view, seen_at: Time.now)
      expect(model.seen?).to eq(true)
    end
  end

  describe '#seen!' do
    it 'should update the record to be seen' do
      model = build(:site_announcement_view, seen_at: nil)
      expect {
        model.seen!
      }.to change { model.seen? }.from(false).to(true)
    end
  end

  describe '#read?' do
    it 'should return false if the read_at is blank' do
      model = build(:site_announcement_view, read_at: nil)
      expect(model.read?).to eq(false)
    end

    it 'should return true if the read_at is set' do
      model = build(:site_announcement_view, read_at: Time.now)
      expect(model.read?).to eq(true)
    end
  end

  describe '#read!' do
    it 'should update the record to be read' do
      model = build(:site_announcement_view, read_at: nil)
      expect {
        model.read!
      }.to change { model.read? }.from(false).to(true)
    end
  end

  describe '.for_user' do
    context 'with user present' do
      it 'should return a Relation of SiteAnnouncementViews for the user' do
        user = create(:user)
        create_list(:site_announcement, 5, show_at: 5.minutes.ago)

        views = SiteAnnouncementView.for_user(user)
        expect(views.count).to eq(5)
        expect(views).to all(have_attributes(user: user))
      end
    end

    context 'with no user' do
      it 'should return an array of unsaved, anonymous SiteAnnouncementViews' do
        create_list(:site_announcement, 5, show_at: 5.minutes.ago)

        views = SiteAnnouncementView.for_user(nil)
        expect(views.count).to eq(5)
        expect(views).not_to include(be_persisted)
        expect(views).to all(have_attributes(user: nil))
      end
    end
  end
end
