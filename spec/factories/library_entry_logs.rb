FactoryBot.define do
  factory :library_entry_log do
    association :linked_account, strategy: :build
    association :media, factory: :anime, strategy: :build
    action_performed { 'create' }
    sync_status { 0 }
  end
end
