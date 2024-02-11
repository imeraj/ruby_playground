require "sqlite3"

conn = SQLite3::Database.new "test.db"
conn.execute <<SQL
    create table quotes (
        id INTEGER PRIMARY KEY,
        posted INTEGER,
        title VARCHAR(30),
        body VARCHAR(32000) 
    );
SQL