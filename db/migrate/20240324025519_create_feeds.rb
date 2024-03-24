class CreateFeeds < ActiveRecord::Migration[6.1]
  def change
    create_table :feeds do |t|
      t.timestamps
    end
  end
end
