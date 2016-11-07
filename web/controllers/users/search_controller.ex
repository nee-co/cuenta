defmodule Cuenta.UserSearchController do
  use Cuenta.Web, :controller

  alias Cuenta.User

  def search(conn, %{"str" => str, "user_ids" => user_ids, "college_codes" => _college_codes}) do
    users = User
    |> User.in_user(~i/#{user_ids}/)
    |> User.like_name_or_number(str)
    |> limit(50)
    |> Repo.all |> Repo.preload(:college)

    render(conn, "search.json", users: users)
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"str" => str, "user_ids" => user_ids}) do
    users = User
    |> User.in_user(~i/#{user_ids}/)
    |> User.like_name_or_number(str)
    |> limit(50)
    |> Repo.all |> Repo.preload(:college)

    render(conn, "search.json", users: users)
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"str" => str, "college_codes" => college_codes}) do
    users = User
    |> User.like_name_or_number(str)
    |> User.in_college(~w/#{String.downcase(college_codes)}/)
    |> limit(50)
    |> Repo.all |> Repo.preload(:college)

    render(conn, "search.json", users: users)
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"str" => str}) do
    users = User
    |> User.like_name_or_number(str)
    |> limit(50)
    |> Repo.all |> Repo.preload(:college)

    render(conn, "search.json", users: users)
  end
end
