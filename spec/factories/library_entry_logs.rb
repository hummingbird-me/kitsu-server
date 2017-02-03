FactoryGirl.define do
  factory :library_entry_log do
    association :linked_account, strategy: :build
    action_performed 'create'
    sync_status 0
  end
end
