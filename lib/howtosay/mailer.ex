defmodule Howtosay.Mailer do
  use Mailgun.Client,
    domain: Application.get_env(:howtosay, :mailgun_domain),
    key: Application.get_env(:howtosay, :mailgun_key)
    # mode: :test,
    # test_file_path: "/tmp/mailgun.json"

  import Howtosay.Gettext

  @from "support@howtosay.site"

  def send_confirmation_email(email, params) do
    send_email to: email,
      from: @from,
      subject: dgettext("emails", "Confirmation email for Howtosay.site"),
      html: html_for("email_confirmation.html", params)
  end

  defp html_for(template, params) do
    Howtosay.EmailView
    |> Phoenix.View.render_to_string(template, %{})
    |> translate(params)
  end

  defp translate(text, params) do
    Howtosay.Gettext |> Gettext.dgettext("emails", text, params)
  end
end
