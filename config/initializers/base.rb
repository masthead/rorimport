module ActiveRecord
  class Base
    class << self
      def temp_table(tmp_table_name)
        original_table_name = self.table_name
        begin
          self.connection.execute("DROP TABLE IF EXISTS #{tmp_table_name}")
          self.connection.execute("CREATE TABLE #{tmp_table_name} (LIKE #{original_table_name} INCLUDING ALL)")
          cls = Class.new(ActiveRecord::Base) do
            acts_as_copy_target
            self.table_name = tmp_table_name
          end
          yield(cls)
        ensure
          self.connection.execute("DROP TABLE IF EXISTS #{tmp_table_name}")
        end
      end
    end
  end
end