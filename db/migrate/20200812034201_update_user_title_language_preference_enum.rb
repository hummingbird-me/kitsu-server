class UpdateUserTitleLanguagePreferenceEnum < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :title_language_preference, from: 'canonical', to: nil
    change_column :users, :title_language_preference, "integer USING (
      CASE lower(title_language_preference)
      WHEN 'canonical' THEN 0
      WHEN 'romanized' THEN 1
      WHEN 'english' THEN 2
      ELSE 0
      END
    )", default: 0
  end
end
