defmodule Cuenta.UserController do
  use Cuenta.Web, :controller

  import Cuenta.UserImageService, only: [upload_image: 1, remove_image: 1]
  import Cuenta.AuthHelper, only: [current_user: 1, authenticate: 2]

  alias Cuenta.User

  def index(conn, _params) do
    render(conn, "user.json", user: current_user(conn))
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

  def image(conn, %{"image" => image}) do
    old_image_path = current_user(conn).image_path
    changeset = User.changeset(current_user(conn), %{ image_path: upload_image(image) })
    case Repo.update(changeset) do
      {:ok, user} ->
        remove_image(old_image_path)
        render(conn, "user.json", user: user)
      _ -> send_resp(conn, 500, "")
    end
  end

  def update_password(conn, %{"current_password" => current_password, "new_password" => new_password}) do
    case authenticate(current_user(conn).number, current_password) do
      {:ok, user} ->
        case User.changeset(user, %{password: new_password}) |> Repo.update do
          {:ok, _} -> send_resp(conn, 204, "")
          _ -> send_resp(conn, 500, "")
        end
      :error ->
        send_resp(conn, 403, "")
    end
  end
end
