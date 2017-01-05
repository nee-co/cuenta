defmodule Cuenta.TokenHelper do
  import Plug.Conn
  import Joken

  def token(conn) do
    [auth_header] = get_req_header(conn, "authorization")
    Regex.named_captures(~r/\ABearer\ (?<token>.*)\z/, auth_header)["token"]
  end

  def claims(token) do
    Joken.token(token) |> Joken.peek
  end

  def jwt(data) do
    expires_at = Timex.now("Asia/Tokyo") |> Timex.shift(weeks: 1)
    token = %Joken.Token{}
    |> with_signer(hs256("secret"))
    |> with_claim("iss", data["key"])
    |> with_claim("exp", expires_at |> Timex.to_unix)
    |> with_signer(hs256(data["secret"]))
    |> sign
    |> get_compact
    {token, expires_at}
  end
end
