# CRUD library
module UserDatabase
  class CreateDb
    attr_accessor :db_name

    def initialize(db_name)
      @db_name = db_name
    end

    def create
      sql='CREATE DATABASE '+@db_name+' CHARACTER SET utf8 COLLATE utf8_bin;'
      ActiveRecord::Base.connection.execute(sql)

    end
    def delete
      sql='DROP DATABASE '+@db_name+';'
      ActiveRecord::Base.connection.execute(sql)

    end

  end


  class ReadDb
    attr_accessor :db_name

    def initialize(db_name)
          @db_name = db_name
    end

    def get_tables
      sql='SHOW TABLES IN '+@db_name+';'
      ActiveRecord::Base.connection.execute(sql)
    end

    def get_columns(table_name)
      sql='SHOW COLUMNS IN '+@db_name+'.'+table_name+';'
      ActiveRecord::Base.connection.execute(sql)
    end

    def show_data(table_name,count,offset)
      sql="SELECT * FROM #{@db_name}.#{table_name} LIMIT #{offset},#{count}"
      ActiveRecord::Base.connection.execute(sql)
    end

  end

end