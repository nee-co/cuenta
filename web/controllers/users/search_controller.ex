defmodule Cuenta.UserSearchController do
  use Cuenta.Web, :controller

  alias Cuenta.User

  def search(conn, %{"str" => str, "user_ids" => user_ids, "college_codes" => _college_codes}) do
    base_query(str) |> User.in_user(~i/#{user_ids}/) |> base_render(conn)
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"str" => str, "user_ids" => user_ids}) do
    base_query(str) |> User.in_user(~i/#{user_ids}/) |> base_render(conn)
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"str" => str, "college_codes" => college_codes}) do
    base_query(str) |> User.in_college(~w/#{String.downcase(college_codes)}/) |> base_render(conn)
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"str" => str}) do
    base_query(str) |> base_render(conn)
  end

  defp base_query(str) do
    User |> User.like_name_or_number(str) |> limit(50)
  end

  defp base_render(query, conn) do
    users = query |> Repo.all |> Repo.preload(:college)
    render(conn, "search.json", users: users)
  end
end
