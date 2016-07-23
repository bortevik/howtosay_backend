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
      post "/refresh_token", SessionController, :update, as: :refresh_token
      delete "/signout", SessionController, :delete, as: :signout

      resources "/languages", LanguageController, only: [:index, :show]
      resources "/questions", QuestionController, except: [:new, :edit]
      resources "/answers", AnswerController, except: [:new, :edit]
      resources "/users", UserController, except: [:new, :edit]
      resources "/question_votes", QuestionVoteController, only: [:show, :create]
      resources "/answer_votes", AnswerVoteController, only: [:show, :create]

      get "/current_user", UserController, :current_user, as: :current_user

      post "/confirm_email", EmailConfirmationController, :confirm_email, as: :confirm_email
      post "/resend_confirmation_email", EmailConfirmationController, :resend_confirmation_email, as: :resend_confirmation_email
    end
  end
end
