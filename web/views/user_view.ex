defmodule Cuenta.UserView do
  use Cuenta.Web, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      number: String.upcase(user.number),
      image: Path.join(Application.get_env(:cuenta, :static_image_url), user.image),
      college: %{code: user.college.code, name: user.college.name},
      note: user.note
    }
  end
end
