class CreateWikiSubmissionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :wiki_submission_logs do |t|
      t.integer :status, null: false, default: 0

      t.references :user, foreign_key: true, index: true
      t.references :wiki_submission, foreign_key: true, index: true

      t.timestamps
    end
  end
end
