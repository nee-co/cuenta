defmodule Cuenta.UserListView do
  use Cuenta.Web, :view

  alias Cuenta.UserView

  def render("list.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("search.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end
end
