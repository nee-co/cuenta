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

  def update_note(conn, %{"note" => note}) do
    case User.changeset(current_user(conn), %{note: note}) |> Repo.update do
      {:ok, user} ->
        render(conn, "user.json", user: user)
      _ -> send_resp(conn, 500, "")
    end
  end
end
