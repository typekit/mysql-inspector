module MysqlInspector
  module AR
    class Access

      def initialize(connection)
        @connection = connection
      end

      def table_names
        tables.map { |t| t.table_name }
      end

      def tables
        dump = @connection.structure_dump
        tables = dump.split(";").map { |schema|
          table = MysqlInspector::Table.new(schema)
          table if table.table_name
        }.compact
        
        puts tables.inspect
        tables
      end

      def drop_all_tables
        @connection.disable_referential_integrity do
          names = table_names
          @connection.execute("DROP TABLE #{names.join(',')}") if names.any?
        end
      end

      def load(schema)
        puts "IN AR"
        
        puts @connection.inspect
        
        @connection.disable_referential_integrity do
          puts "Inside of the execution block"
          schema.split(";").each { |table|
            puts "TABLE: #{table}"
            a = @connection.execute(table)
            puts a.inspect
          }
        end
      end

      def read_migrations(table_name)
        if table_names.include?(table_name)
          @connection.select_values("SELECT * FROM #{table_name}")
        else
          []
        end
      end

      def write_migrations(table_name, col, values)
        if table_names.include?(table_name)
          values = values.map { |value| "('#{value}')" }
          @connection.execute("INSERT INTO #{table_name} (#{col}) VALUES #{values * ','}")
        end
      end
    end

  end
end


