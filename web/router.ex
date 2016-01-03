defmodule Howtosay.Router do
  use Howtosay.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Howtosay do
    pipe_through :api
  end
end
