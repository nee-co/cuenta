defmodule Cuenta.Plug.RequireLogin do
  import Plug.Conn

  alias Cuenta.User
  alias Cuenta.Repo

  def init(default), do: default

  def call(conn, _) do
    case get_req_header(conn, "x-consumer-custom-id") do
      [user_id] ->
        assign(conn, :current_user, Repo.get!(User, user_id) |> Repo.preload(:college))
      _ -> send_resp(conn, 401, "") |> halt
    end
  end
end
