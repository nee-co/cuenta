defmodule Cuenta.AuthController do
  use Cuenta.Web, :controller

  import Cuenta.AuthHelper, only: [authenticate: 2]

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
end
