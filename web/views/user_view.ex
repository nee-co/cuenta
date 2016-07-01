defmodule Cuenta.UserView do
  use Cuenta.Web, :view

  def render("user.json", %{user: user}) do
    %{user_id: user.id,
      name: user.name,
      number: user.number,
      college_id: user.college_id}
  end
end
