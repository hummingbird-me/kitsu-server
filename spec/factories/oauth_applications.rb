FactoryBot.define do
  factory :oauth_application, class: ::Doorkeeper::Application do
    name { Faker::Internet.username }
    redirect_uri { Faker::Internet.url(host: 'example.com').sub('http', 'https') }
    association :owner, factory: :user, strategy: :build
  end
end
