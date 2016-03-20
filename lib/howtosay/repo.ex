defmodule Howtosay.Repo do
  use Ecto.Repo, otp_app: :howtosay
  use Scrivener, page_size: 100
end
