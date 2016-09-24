defmodule Cuenta.Plug.RequireLogin do
  import Plug.Conn

  alias Cuenta.User
  alias Cuenta.Repo

  def init(default), do: default

  def call(conn, _) do
    case conn.req_headers |> Enum.find(&elem(&1, 0) == "x-consumer-custom-id") do
      { "x-consumer-custom-id", user_id } ->
        assign(conn, :current_user, Repo.get!(User, user_id) |> Repo.preload(:college))
      _ -> send_resp(conn, 401, "")
    end
  end
end
