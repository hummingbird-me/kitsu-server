class CreateWikiSubmissionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :wiki_submission_logs do |t|
      t.integer :status, null: false, default: 0

      t.references :user
      t.references :wiki_submission

      t.timestamps
    end
  end
end
