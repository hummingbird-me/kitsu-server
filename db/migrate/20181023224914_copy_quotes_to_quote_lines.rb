class CopyQuotesToQuoteLines < ActiveRecord::Migration[4.2]
  def change
    execute <<-SQL.squish
      INSERT INTO quote_lines (
        quote_id,
        character_id,
        "order",
        content,
        created_at,
        updated_at
      )
      SELECT
        id,
        character_id,
        1 AS "order",
        content,
        created_at,
        updated_at
      FROM quotes
      WHERE character_id IS NOT NULL
    SQL
  end
end
