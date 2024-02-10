# Mock database
# (it just stores the SQL)
class Database
  @sql = []

  def self.sql(sql)
    @sql << sql
  end

  def self.read_sql
    @sql
  end
end

class Entity
  attr_reader :table, :ident

  def initialize(table, ident)
    @table = table
    @ident = ident
    Database.sql "insert into #{table} (id) values (#{ident})"
  end

  def set(col, val)
    Database.sql "update #{table} set #{col} = '#{val}' where id = #{ident}"
  end

  def get(col)
    Database.sql "select #{col} from #{table} where id = #{ident}"
  end
end

class Movie < Entity
  def initialize(ident)
    super('movies', ident)
  end

  def title
    get('title')
  end

  def title=(val)
    set('title', val)
  end

  def director
    get('director')
  end

  def director=(val)
    set('director', val)
  end
end

movie = Movie.new(1)
movie.title = 'Doctor Strangelove'
movie.director = 'Stanely Kubrick'
