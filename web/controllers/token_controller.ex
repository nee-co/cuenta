defmodule Cuenta.TokenController do
  use Cuenta.Web, :controller

  import Cuenta.AuthHelper, only: [authenticate: 2, current_user: 1]

  alias Cuenta.KongClientService

  plug Cuenta.Plug.RequireLogin when action in ~w(refresh)a

  def create(conn, %{"number" => number, "password" => password}) do
    case authenticate(number, password) do
      {:ok, login_user} ->
        {token, expires_at} = KongClientService.register_token(login_user)
        render(conn, "login.json", token: token, expires_at: expires_at)
      :error ->
        send_resp(conn, 404, "")
    end
  end

  def refresh(conn, _params) do
    {token, expires_at} = KongClientService.register_token(current_user(conn))
    render(conn, "login.json", token: token, expires_at: expires_at)
  end
end
