# frozen_string_literal:
require "erubis"
require "rulers/version"
require "rulers/routing"
require "rack/request"

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
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      if env['PATH_INFO'] == '/'
        [301, {'Content-Type' => 'text/html', 'Location' => '/quotes/a_quote'}, []] # Browser redirect
      else
        klass, act = Routing.get_controller_and_action(env)
        controller = klass.new(env)
        resp = controller.send(act)
        if controller.get_response
          st, hd, rs = controller.get_response.to_a
          [st, hd, rs]
        else
          [200, {'Content-Type' => 'text/html'}, [resp]]
        end
      end
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def request
      @request ||= Rack::Request.new(env)
    end

    def params
      request.params
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
