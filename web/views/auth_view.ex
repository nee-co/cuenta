defmodule Cuenta.AuthView do
  use Cuenta.Web, :view

  def render("login.json", %{token: token, user: user}) do
    %{token: token,
      user_id: user.id,
      name: user.name,
      number: String.upcase(user.number),
      user_image: Application.get_env(:cuenta, :image_url) <> user.image_path,
      college: %{code: user.college.code, name: user.college.name}}
  end
end
