require "sqlite3"
require "rulers"

class Quotes < Rulers::Model::SQLite; end

STDERR.puts Quotes.schema.inspect

# Create row
attrs = { "title" => "It happened!", "posted" => 1, "body" => "It did!" }
Quotes.create(attrs)

attrs = { "title" => "I saw it!" }
quote = Quotes.create(attrs)

puts "updating"
quote["title"] = "OK, right"
p quote.save

puts "Count: #{Quotes.count}"

top_id = quote["id"].to_i
(1..top_id).each do |id|
  quote = Quotes.find(id)
  puts "Found title #{quote["title"]} with id #{quote["id"]}"
end

attrs = { "title" => "I saw it!" }
quote = Quotes.new(attrs).save
p quote