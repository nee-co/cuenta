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

  def search(conn, params) do
    users = User
    |> User.like_name_or_number(Map.fetch!(params, "str"))
    |> targets(params)
    |> User.not_in_user(~i/#{Map.get(params, "except_ids")} #{current_user(conn).id}/)
    |> limit(50)
    |> Repo.all |> Repo.preload(:college)

    render(conn, "search.json", users: users)
  rescue
    KeyError -> send_resp(conn, 400, "")
    ArgumentError -> send_resp(conn, 400, "")
  end

  defp targets(query, params) do
    case Map.fetch(params, "user_ids") do
      {:ok, user_ids} -> query |> User.in_user(~i/#{user_ids}/)
      _ ->
        case Map.fetch(params, "college_codes") do
          {:ok, college_codes} -> query |> User.in_college(~w/#{String.downcase(college_codes)}/)
          _ -> query
        end
    end
  end
end
