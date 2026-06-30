class Mutations::Pro < Mutations::Namespace
  # Subscription Management
  field :unsubscribe,
    mutation: Mutations::Pro::Unsubscribe,
    description: "End the user's pro subscription"

  # Benefits Management
  field :set_message,
    mutation: Mutations::Pro::SetMessage,
    description: "Set the user's Hall-of-Fame message"
  field :set_discord,
    mutation: Mutations::Pro::SetDiscord,
    description: "Set the user's discord tag"
end
