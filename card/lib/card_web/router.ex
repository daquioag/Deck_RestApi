defmodule CardWeb.Router do
  use CardWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CardWeb do
    pipe_through :api
    get "/new", CardController, :new
    get "/value", CardController, :value
    get "/shuffle", CardController, :shuffle
    get "/count", CardController, :count
    get "/deal/:qty", CardController, :deal_qty
    post "/deal", CardController, :deal
  end
end
