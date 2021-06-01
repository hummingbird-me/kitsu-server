require 'rails_helper'

RSpec.describe WikiSubmission, type: :model do
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to have_many(:logs).class_name('WikiSubmissionLog').dependent(:destroy) }
  it { is_expected.to belong_to(:parent).inverse_of(:child).class_name('WikiSubmission').optional }

  it do
    expect(subject).to have_one(:child).inverse_of(:parent).class_name('WikiSubmission')
                                       .with_foreign_key(:parent_id).dependent(:destroy)
  end
end
