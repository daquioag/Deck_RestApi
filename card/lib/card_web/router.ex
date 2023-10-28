defmodule CardWeb.Router do
  use CardWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CardWeb do
    pipe_through :api
  end
end
