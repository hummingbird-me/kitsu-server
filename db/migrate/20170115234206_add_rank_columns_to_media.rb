class AddRankColumnsToMedia < ActiveRecord::Migration
  def change
    change_table :anime do |t|
      t.integer :popularity_rank
      t.integer :rating_rank
    end
    change_table :manga do |t|
      t.integer :popularity_rank
      t.integer :rating_rank
    end
    change_table :dramas do |t|
      t.integer :popularity_rank
      t.integer :rating_rank
    end
  end
end
