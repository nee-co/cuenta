defmodule Cuenta.AuthController do
  use Cuenta.Web, :controller

  alias Cuenta.User
  alias Cuenta.KongClientService

  def login(conn, %{"number" => number, "password" => password}) do
    case authenticate(number, password) do
      {:ok, login_user} ->
        token = KongClientService.register_token(login_user.id, login_user.number)
        render(conn, "login.json", token: token, user: login_user)
      :error ->
        send_resp(conn, 404, "")
    end
  end

  def login(conn, _params) do
    send_resp(conn, 400, "")
  end

  defp authenticate(number, password) do
    user = Repo.get_by!(User, number: String.downcase(number)) |> Repo.preload(:college)
    case Comeonin.Bcrypt.checkpw(password, user.encrypted_password) do
      true -> {:ok, user}
      _    -> :error
    end
  rescue
    Ecto.NoResultsError -> :error
  end
end
