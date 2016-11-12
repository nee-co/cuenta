defmodule Cuenta.AuthController do
  use Cuenta.Web, :controller

  import Cuenta.AuthHelper, only: [authenticate: 2, current_user: 1]

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

  def update_token(conn, _params) do
    user = current_user(conn)
    token = KongClientService.register_token(user.id, user.number)
    render(conn, "login.json", token: token, user: user)
  end
end
