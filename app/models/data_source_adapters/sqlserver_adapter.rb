module DataSourceAdapters
  class SqlserverAdapter < StandardAdapter
    def fetch_table_names
      source_base_class.connection.query(<<~SQL, 'SCHEMA')
        SELECT table_schema
             , table_name
          FROM information_schema.tables
         WHERE table_type = 'BASE TABLE';
      SQL
    rescue ActiveRecord::ActiveRecordError, TinyTds::Error => e
      raise DataSource::ConnectionBad.new(e)
    end

    def fetch_columns(table)
      adapter = connection.pool.connection
      raw_columns(table).map { |c| Column.new(c.name, c.sql_type, adapter.quote(c.default), c.null) }
    rescue ActiveRecord::ActiveRecordError, TinyTds::Error => e
      raise DataSource::ConnectionBad.new(e)
    end

    def fetch_rows(table, limit)
      adapter = connection.pool.connection
      rows = connection.select_rows(<<~SQL, "#{table.full_table_name.classify} Load")
        SELECT TOP #{limit} * FROM #{adapter.quote_table_name(table.full_table_name)}
      SQL
      rows.map {|row|
        raw_columns(table).zip(row).map {|column, value|
          case column.type
          when :ss_timestamp, :image, :binary, :varbinary
            '0x' + value.unpack('H*')[0]
          else
            value
          end
        }
      }
    rescue ActiveRecord::ActiveRecordError, TinyTds::Error => e
      raise DataSource::ConnectionBad.new(e)
    end

    def fetch_count(table)
      adapter = connection.pool.connection
      connection.select_value(<<-SQL).to_i
        SELECT sum(partitions.rows) AS row_count
          FROM sys.tables AS tables
          JOIN sys.partitions AS partitions
            ON tables.object_id = partitions.object_id
           AND partitions.index_id IN (0, 1)
         WHERE tables.name = #{adapter.quote(table.table_name)}
      SQL
    rescue ActiveRecord::ActiveRecordError, TinyTds::Error => e
      raise DataSource::ConnectionBad.new(e)
    end
  end
end
