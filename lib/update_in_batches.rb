module UpdateInBatches
  # rubocop:disable all
  refine ActiveRecord::Relation do
    def update_in_batches(updates, of: 10000)
      relation = self
      relation = relation.reorder(batch_order).limit(of)
      batch_relation = relation

      loop do
        # Optimization: we only need to know if there's > 1, so we `limit 1`
        break if batch_relation.limit(1).empty?
        # Optimization: Use offset and limit to get the last id in the batch
        offset = batch_relation.offset(of - 1).limit(1).pluck(:id)[0]
        # Perform the update and store the update count returned by Postgres
        updated_count = batch_relation.update_all(updates)
        # If it's less than we expect, we've hit the last page
        break if updated_count < of
        # Set up the next batch
        batch_relation = relation.where(table[primary_key].gt(offset))
      end
    end

    private

    def batch_order
      "#{quoted_table_name}.#{quoted_primary_key} ASC"
    end
  end
end
