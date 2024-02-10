class QuotesController < Rulers::Controller
  def index
    quotes = Rulers::FileModel.all
    render_response :index, quotes: quotes
  end

  def a_quote
    render_response :a_quote, noun: :winking
  end

  def show
    quote = Rulers::FileModel.find(params["id"])
    render_response :show, obj: quote
  end

  def create
    attrs = {
      "submitter" => "web user",
      "quote" => "A picture is worth a thousand pixels",
      "attribution" => "Me"
    }
    quote = Rulers::FileModel.create(attrs)
    render_response :show, obj: quote
  end

  def update
    if env["REQUEST_METHOD"] == "POST"
      id = env["REQUEST_PATH"].split("/").last.to_i
      quote = Rulers::FileModel.update(id, params)
      render_response :show, obj: quote
    end
  end
end