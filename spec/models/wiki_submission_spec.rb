require 'rails_helper'

RSpec.describe WikiSubmission, type: :model do
  it { should belong_to(:user).required }
  it { should have_many(:logs).class_name('WikiSubmissionLog').dependent(:destroy) }
  it do
    should belong_to(:parent).inverse_of(:child).class_name('WikiSubmission')
                             .with_foreign_key(:parent_id).optional
  end
  it do
    should have_one(:child).inverse_of(:parent).class_name('WikiSubmission')
                           .with_foreign_key(:parent_id).dependent(:destroy)
  end
end
