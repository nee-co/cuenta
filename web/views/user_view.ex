defmodule Cuenta.UserView do
  use Cuenta.Web, :view

  alias Cuenta.UserView

  def render("list.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{user_id: user.id,
      name: user.name,
      number: user.number,
      college_id: user.college_id}
  end
end
