defmodule Cuenta.AuthView do
  use Cuenta.Web, :view

  def render("login.json", %{token: token, user: user}) do
    %{token: token,
      user_id: user.id,
      name: user.name,
      number: user.number,
      college: %{code: user.college.code, name: user.college.name}}
  end
end
