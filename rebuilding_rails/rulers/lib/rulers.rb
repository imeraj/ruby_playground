# frozen_string_literal:
require "erubis"
require "rulers/version"
require "rulers/routing"
require "rack/request"
require "rack/response"
require "sqlite3"

module Rulers
  def self.to_underscore(string)
    string.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
end

module Rulers
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'content-type' => 'text/html'}, ["Not Found"]]
      end

      rack_app = get_rack_app(env)
      rack_app.call(env)
    end

    def route(&block)
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval(&block)
    end

    def get_rack_app(env)
      raise "No routes!" unless @route_obj
      @route_obj.check_url(env["PATH_INFO"])
    end
  end

  class Controller
    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      text = self.send(action)
      if get_response
        st, hd, rs = get_response.to_a
        [st, hd, rs]
      else
        [200, {'Content-Type' => 'text/html'}, [text]]
      end
    end

    def self.action(act, routing_params = {})
      proc { |e| self.new(e).dispatch(act, routing_params)}
    end

    def env
      @env
    end

    def request
      @request ||= Rack::Request.new(env)
    end

    def params
      request.params.merge(@routing_params)
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, "")
      Rulers.to_underscore klass
    end

    def render(view_name, locals = {})
      filename = File.join "app", "views", controller_name, "#{view_name}.html.erb"
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(:env => env)
    end

    def response(resp, status = 200, headers = {})
      raise "Already responded" if @response
      resp = [resp].flatten
      @response = Rack::Response.new(resp, status, headers)
    end

    def get_response
      @response
    end

    def render_response(*args)
      response(render(*args))
    end
  end
end

class Object
  def self.const_missing(c)
    require Rulers.to_underscore(c.to_s)
    if Object.const_defined?(c)
      Object.const_get(c)
    else
      nil
    end
  end
end

require "multi_json"

module Rulers
  class FileModel
    def initialize(filename)
      @filename = filename

      basename = File.split(filename)[-1]
      @id = File.basename(basename, ".json").to_i

      obj = File.read(filename)
      @hash = MultiJson.load(obj)
    end

    def self.create(attrs)
      hash = {}
      hash["submitter"] = attrs["submitter"] || ""
      hash["quote"] = attrs["quote"] || ""
      hash["attribution"] = attrs["attribution"] || ""

      files = Dir["db/quotes/*.json"]
      ids = files.map { |f| File.basename(f, ".json").to_i }
      id = if ids.empty? then 1 else ids.max + 1 end

      File.open("db/quotes/#{id}.json", "w") do |f|
        f.write <<TEMPLATE
{
  "submitter": "#{hash["submitter"]}",
  "quote": "#{hash["quote"]}",
  "attribution": "#{hash["attribution"]}"
}
TEMPLATE
      end
       
      FileModel.new("db/quotes/#{id}.json")
    end

    def self.update(id, attrs)
      model = FileModel.find(id)
      return nil if model.nil?

      hash = {}
      hash["submitter"] = attrs["submitter"] || model[:submitter]
      hash["quote"] = attrs["quote"] || model[:quote]
      hash["attribution"] = attrs["attribution"] || model[:attribution]

      File.open("db/quotes/#{id}.json", "w+") do |f|
        f.write <<TEMPLATE
{
  "submitter": "#{hash["submitter"]}",
  "quote": "#{hash["quote"]}",
  "attribution": "#{hash["attribution"]}"
}
TEMPLATE
      end

      FileModel.new("db/quotes/#{id}.json")
    end

    def [](name)
      @hash[name.to_s]
    end

    def []=(name, value)
      @hash[name.to_s] = value
    end

    def self.all
      files = Dir["db/quotes/*.json"]
      files.map { |f| FileModel.new(f) }
    end

    def self.find(id)
      begin
        FileModel.new("db/quotes/#{id}.json")
      rescue
        return nil
      end
    end
  end
end

DB = SQLite3::Database.new("test.db")

module Rulers
  module Model
    class SQLite
      def initialize(data = {})
        @hash = data
      end

      def [](name)
        @hash[name].to_s
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.table
        Rulers.to_underscore(name)
      end

      def self.schema
        return @schema if @schema
        @schema = {}
        DB.table_info(table) do |row|
          @schema[row["name"]] = row["type"]
        end
        @schema
      end

      def self.to_sql(val)
        case val
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't change #{val.class} to SQL!"
        end
      end

      def self.create(values)
        values.delete "id"
        keys = schema.keys - ["id"]
        vals = keys.map do |key|
          values[key] ? to_sql(values[key]) : "null"
        end

        DB.execute <<SQL
        INSERT INTO #{table} (#{keys.join(",")}) values (#{vals.join(",")});
SQL

        data = Hash[keys.zip(vals)]
        sql = "SELECT last_insert_rowid();"
        data["id"] = DB.execute(sql)[0][0]
        self.new(data)
      end

      def self.count
        count = DB.execute <<SQL
        SELECT COUNT(*) FROM #{table}    
SQL
        count.flatten
      end

      def self.find(id)
        row = DB.execute <<SQL
        select #{schema.keys.join(",")} from #{table} where id = #{id};
SQL
        data = Hash[schema.keys.zip(row[0])]
        self.new(data)
      end

      def save!
        unless @hash["id"]
          return self.class.create(@hash)
        end

        # otherwise do update
        fields = @hash.map do |k, v|
          "#{k}=#{self.class.to_sql(v)}"
        end.join(",")

        DB.execute <<SQL
        UPDATE #{self.class.table}
        SET #{fields}
        WHERE id = #{@hash["id"]}
SQL
      end

      def save
        self.save!
      end
    end
  end
end
