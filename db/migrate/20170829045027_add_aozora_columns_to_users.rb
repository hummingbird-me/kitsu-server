class AddAozoraColumnsToUsers < ActiveRecord::Migration
  def change
    # Normally we'd prefer to store this in Mappings but that would slow down lookups significantly.
    add_column :users, :ao_id, :string
    # For most users we can just put the Aozora password in our own password_digest, but if they
    # already had a Kitsu account we need to accept *both* passwords.
    add_column :users, :ao_password, :string
    # Technically this could be shoved in the same facebook_id column, but with this we can track
    # the transition to Kitsu IDs over time
    add_column :users, :ao_facebook_id, :string
    # Track the Aozora Pro status
    add_column :users, :ao_pro, :integer
  end
end
