defmodule Cuenta.UserSearchView do
  use Cuenta.Web, :view

  alias Cuenta.UserView

  def render("search.json", %{users: users}) do
    %{total_count: length(users),
    users: render_many(users, UserView, "user.json")}
  end
end
