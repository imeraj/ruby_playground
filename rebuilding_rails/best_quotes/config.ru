require_relative 'config/application'
require "rack/content_type"

app = BestQuotes::Application.new

use Rack::ContentType

app.route do
  match "", "quotes#index"
  match "quotes/a_quote", "quotes#a_quote"
  match "sub-app",
       proc { [200, {}, ["Hello, sub-app!"]] }

  # default routes
  match ":controller/:id/:action"
  match ":controller/:id",
        :default => { "action" => "show" }
  match ":controller",
        :default => { "action" => "index" }
end

run app