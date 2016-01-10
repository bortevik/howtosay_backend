defmodule Howtosay.Router do
  use Howtosay.Web, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/api", Howtosay.Api do
    pipe_through :api

    scope "/v1", V1 do
      resources "/questions", QuestionController, except: [:new, :edit]
      resources "/answers", AnswerController, except: [:new, :edit]
    end
  end
end
