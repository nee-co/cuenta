defmodule Cuenta.UserController do
  use Cuenta.Web, :controller

  alias Cuenta.User

  def index(conn, _params) do
    current_user_id = conn.req_headers
                 |> Enum.find(&elem(&1, 0) == "x-consumer-custom-id")
                 |> elem(1)
    user = Repo.get!(User, current_user_id) |> Repo.preload(:college)
    render(conn, "user.json", user: user)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id) |> Repo.preload(:college)
    render(conn, "user.json", user: user)
  rescue
    Ecto.NoResultsError -> send_resp(conn, 404, "")
  end

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

  def list(conn, _params) do
    send_resp(conn, 400, "")
  end

  def search(conn, %{"str" => str, "user_ids" => user_ids, "college_codes" => _college_codes}) do
    users = User
    |> User.in_user(~i/#{user_ids}/)
    |> User.like_name_or_number(str)
    |> Repo.all |> Repo.preload(:college)
    render(conn, "search.json", users: users)
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"str" => str, "user_ids" => user_ids}) do
    users = User
    |> User.in_user(~i/#{user_ids}/)
    |> User.like_name_or_number(str)
    |> Repo.all |> Repo.preload(:college)

    render(conn, "search.json", users: users)
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"str" => str, "college_codes" => college_codes}) do
    users = User
    |> User.like_name_or_number(str)
    |> User.in_college(~w/#{String.downcase(college_codes)}/)
    |> Repo.all |> Repo.preload(:college)

    render(conn, "search.json", users: users)
  rescue
    ArgumentError -> send_resp(conn, 400, "")
  end

  def search(conn, %{"str" => str}) do
    users = User
    |> User.like_name_or_number(str)
    |> Repo.all |> Repo.preload(:college)

    render(conn, "search.json", users: users)
  end

  def search(conn, _params) do
    send_resp(conn, 400, "")
  end
end
