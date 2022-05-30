require 'rails_helper'

RSpec.describe Chapter, type: :model do
  subject { create(:chapter) }

  let(:manga) { create(:manga) }

  it { is_expected.to belong_to(:manga).required }
  it { is_expected.to validate_presence_of(:number) }

  it 'strips XSS from description' do
    subject.description['en'] = '<script>prompt("PASSWORD:")</script>' * 3
    subject.save!
    expect(subject.description['en']).not_to include('<script>')
  end
end
