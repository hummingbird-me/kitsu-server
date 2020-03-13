class Types::MutationType < Types::BaseObject
  # rubocop:disable Layout/LineLength

  # Kitsu Pro
  field :subscribe_with_stripe, mutation: Mutations::Pro::SubscribeWithStripe, description: 'Subscribe to Pro using Stripe'
  field :unsubscribe_pro, mutation: Mutations::Pro::Unsubscribe, description: "End the user's pro subscription"
  field :set_pro_message, mutation: Mutations::Pro::SetMessage, description: "Set the user's Hall-of-Fame message"
  field :set_pro_discord, mutation: Mutations::Pro::SetDiscord, description: "Set the user's discord tag"

  # Anime
  field :anime_update, mutation: Mutations::Anime::Update, description: 'Update an Anime'
  field :anime_create, mutation: Mutations::Anime::Create, description: 'Create an Anime'
  field :anime_delete, mutation: Mutations::Anime::Delete, description: 'Delete an Anime'

  # rubocop:enable Layout/LineLength
end
