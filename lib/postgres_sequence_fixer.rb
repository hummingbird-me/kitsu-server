class PostgresSequenceFixer
  def self.run
    sequences.each { |s| new(s).run }
  end

  def self.sequences
    execute(<<-SQL).values.flatten
      SELECT relname
      FROM pg_class
      WHERE relkind = 'S'
    SQL
  end

  def initialize(sequence_name)
    @sequence_name = sequence_name
  end

  def run
    execute(<<-SQL)
      SELECT SETVAL(
        '#{info[:sequence]}',
        COALESCE(MAX(#{info[:column]}), 1)
      )
      FROM #{info[:table]}
    SQL
  end

  def info
    execute(<<-SQL).first.symbolize_keys
      SELECT
        S.relname AS sequence,
        C.attname AS column,
        T.relname AS table
      FROM
        pg_class AS S,
        pg_depend AS D,
        pg_class AS T,
        pg_attribute AS C
      WHERE S.relkind = 'S'
        AND S.oid = D.objid
        AND D.refobjid = T.oid
        AND D.refobjid = C.attrelid
        AND D.refobjsubid = C.attnum
        AND S.relname = '#{@sequence_name}'
    SQL
  end

  def self.execute(sql)
    ApplicationRecord.connection.execute(sql.squish)
  end
  delegate :execute, to: :class
end
