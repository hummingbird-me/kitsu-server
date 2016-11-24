module CounterCacheResets
  module_function

  def posts
    execute sql_for(Post, :post_likes)
    execute sql_for(Post, :comments)
    execute sql_for(Post, :comments,
                    counter_cache_column: 'top_level_comments_count',
                    where: 'parent_id IS NULL')
  end

  def sql_for(model, association_name, counter_cache_column: nil, where: nil)
    association = model.reflections[association_name.to_s]
    inverse = association.inverse_of
    counter_cache_column ||= inverse.counter_cache_column
    temp_table = "#{model}_#{association.name}_count"
    [
      <<-SQL.squish,
        CREATE TEMP TABLE #{temp_table} AS
        SELECT #{association.foreign_key}, count(*) AS count
        FROM #{association.table_name}
        #{where ? "WHERE #{where}" : ''}
        GROUP BY #{association.foreign_key}
      SQL
      "CREATE INDEX ON #{temp_table} (post_id)",
      "VACUUM #{temp_table}",
      <<-SQL.squish,
        UPDATE #{model.table_name}
        SET #{counter_cache_column} = COALESCE((
          SELECT count
          FROM #{temp_table}
          WHERE #{association.foreign_key} = #{model.table_name}.id
        ), 0)
      SQL
      "DROP TABLE #{temp_table}"
    ]
  end

  def execute(sql, title = 'Executing SQL')
    if sql.respond_to?(:each)
      say_with_time(title) do
        sql.each do |query|
          say("#{query}", true)
          ActiveRecord::Base.connection.execute(query)
        end
      end
    else
      say_with_time(sql) do
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end

  # Method pulled from ActiveRecord::Migration (under MIT, not Apache)
  def say(message, subitem=false)
    puts "#{subitem ? "   ->" : "--"} #{message}"
  end

  # Method pulled from ActiveRecord::Migration (under MIT, not Apache)
  def say_with_time(message)
    say(message)
    result = nil
    time = Benchmark.measure { result = yield }
    say "%.4fs" % time.real, :subitem
    say("#{result} rows", :subitem) if result.is_a?(Integer)
    result
  end

  def progress_bar(title, count)
    ProgressBar.create(
      title: title,
      total: count,
      output: STDERR,
      format: '%a (%p%%) |%B| %E %t'
    )
  end
end
