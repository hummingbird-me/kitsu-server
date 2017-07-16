class AddTbaToMedia < ActiveRecord::Migration
  def change
    %i[anime dramas].each do |table|
      change_table table do |t|
        t.string :tba
        t.remove :started_airing_date_known
      end
    end

    add_column :manga, :tba, :string
  end
end
