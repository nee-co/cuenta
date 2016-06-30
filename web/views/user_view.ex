defmodule Cuenta.UserView do
  use Cuenta.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Cuenta.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Cuenta.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      number: user.number,
      crypted_password: user.crypted_password,
      college_id: user.college_id}
  end
end
