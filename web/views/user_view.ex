defmodule Cuenta.UserView do
  use Cuenta.Web, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      number: String.upcase(user.number),
      image: Application.get_env(:cuenta, :static_url) <> user.image_path,
      college: %{code: user.college.code, name: user.college.name},
      note: user.note
    }
  end
end
