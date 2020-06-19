require 'rails_helper'

RSpec.describe Scrape, type: :model do
  it { should define_enum_for(:status).with_values(%i[queued running failed completed]) }
  it { should belong_to(:parent).class_name('Scrape') }
  it do
    should have_many(:children).class_name('Scrape').with_foreign_key(:parent_id)
                               .dependent(:destroy)
  end
end
