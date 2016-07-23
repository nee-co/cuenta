defmodule Cuenta.AuthView do
  use Cuenta.Web, :view

  def render("login.json", %{user: user}) do
    %{user_id: user.id,
      name: user.name,
      number: user.number,
      college: %{code: user.college.code, name: user.college.name}}
  end
end
