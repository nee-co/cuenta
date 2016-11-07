defmodule Cuenta.UserView do
  use Cuenta.Web, :view

  alias Cuenta.UserView

  def render("list.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("search.json", %{users: users}) do
    %{total_count: length(users),
    users: render_many(users, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{user_id: user.id,
      name: user.name,
      number: String.upcase(user.number),
      user_image: Application.get_env(:cuenta, :image_url) <> user.image_path,
      college: %{code: user.college.code, name: user.college.name}}
  end
end
