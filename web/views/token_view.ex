defmodule Cuenta.TokenView do
  use Cuenta.Web, :view

  def render("token.json", %{token: token, expires_at: expires_at}) do
    %{
      token: token,
      expires_at: expires_at
    }
  end

  def render("question.json", %{id: id, message: message}) do
    %{
      id: id,
      message: message
    }
  end
end
