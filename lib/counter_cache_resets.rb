module CounterCacheResets
  module_function

  def posts
    execute sql_for(Post, :post_likes)
    execute sql_for(Post, :comments)
    execute sql_for(Post, :comments,
                    counter_cache_column: 'top_level_comments_count',
                    where: 'parent_id IS NULL')
  end

  def media_user_counts
    execute sql_for(Anime, :library_entries)
    execute sql_for(Manga, :library_entries)
  end

  def reviews
    execute sql_for(User, :reviews)
  end

  def clean!
    tables = ActiveRecord::Base.connection.tables.grep(/_count\z/)
    execute tables.map { |t| "DROP TABLE #{t}" }
  end

  def sql_for(model, association_name, counter_cache_column: nil, where: nil)
    association = model.reflections[association_name.to_s]
    inverse = association.inverse_of
    is_polymorphic = inverse.polymorphic?
    counter_cache_column ||= inverse.counter_cache_column
    temp_table = "#{model}_#{association.name}_count"
    poly_where = "#{inverse.foreign_type} = '#{model.name}'" if is_polymorphic
    where = [where, poly_where].compact.join(' AND ')
    [
      <<-SQL.squish,
        CREATE TEMP TABLE #{temp_table} AS
        SELECT #{is_polymorphic && "#{inverse.foreign_type}, "}
               #{association.foreign_key}, count(*) AS count
        FROM #{association.table_name}
        #{where.present? ? "WHERE #{where}" : ''}
        GROUP BY #{is_polymorphic && "#{inverse.foreign_type}, "}
                 #{association.foreign_key}
      SQL
      <<-SQL.squish,
        CREATE INDEX ON #{temp_table} (
          #{is_polymorphic && "#{inverse.foreign_type}, "}
          #{association.foreign_key}
        )
      SQL
      "VACUUM #{temp_table}",
      <<-SQL.squish,
        UPDATE #{model.table_name}
        SET #{counter_cache_column} = COALESCE((
          SELECT count
          FROM #{temp_table}
          WHERE #{association.foreign_key} = #{model.table_name}.id
            #{is_polymorphic && "AND #{poly_where}"}
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
