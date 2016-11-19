defmodule Cuenta.UserListController do
  use Cuenta.Web, :controller

  import Cuenta.AuthHelper, only: [current_user: 1]

  alias Cuenta.User

  def list(conn, %{"user_ids" => user_ids}) do
    ids = ~i/#{user_ids}/

    users = User |> where([u], u.id in ^ids) |> Repo.all |> Repo.preload(:college)

    if length(users) == length(ids) do
      render(conn, "list.json", users: users)
    else
      send_resp(conn, 404, "")
    end
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"name" => name, "limit" => limit, "offset" => offset, "except_ids" => except_ids}) do
    users = User
    |> User.like_name(name)
    |> User.not_in_user(~i/#{except_ids} #{current_user(conn).id}/)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all |> Repo.preload(:college)

    render(conn, "search.json", users: users)
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"number" => number, "except_ids" => except_ids}) do
    users = User
    |> User.like_number(number)
    |> User.not_in_user(~i/#{except_ids} #{current_user(conn).id}/)
    |> limit(2)
    |> Repo.all |> Repo.preload(:college)

    case length(users) do
      1 -> render(conn, "search.json", users: users)
      _ -> render(conn, "search.json", users: [])
    end
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end
end
