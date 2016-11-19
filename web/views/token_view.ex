defmodule Cuenta.TokenView do
  use Cuenta.Web, :view

  def render("login.json", %{token: token, expires_at: expires_at}) do
    %{
      token: token,
      expires_at: expires_at
    }
  end
end
