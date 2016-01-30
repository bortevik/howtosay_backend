defmodule Howtosay.Router do
  use Howtosay.Web, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Howtosay.Api do
    pipe_through :api

    scope "/v1", V1 do
      post "/signin", SessionController, :create, as: :signin
      post "/token_refresh", SessionController, :update, as: :token_refresh
      delete "/signout", SessionController, :delete, as: :signout

      resources "/questions", QuestionController, except: [:new, :edit]
      resources "/answers", AnswerController, except: [:new, :edit]
      resources "/users", UserController, except: [:new, :edit, :index]
    end
  end
end
