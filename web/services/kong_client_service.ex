defmodule Cuenta.KongClientServiceError do
 defexception message: "kong connect error"
end

defmodule Cuenta.KongClientService do
  import Joken
  alias Cuenta.Kong
  alias Cuenta.KongClientServiceError

  def register_token(user) do
    id = consumer(user)["id"]
    case Kong.post("/consumers/#{id}/jwt", {:form, []}) do
      {:ok, res} ->
        case res.status_code do
          201 -> res.body |> jwt
          _ -> raise KongClientServiceError, "unexpected status_code"
        end
      _ -> raise KongClientServiceError
    end
  end

  defp consumer(user) do
    case Kong.get("/consumers/#{user.number}") do
      {:ok, res} ->
        case res.status_code do
          200 -> res.body
          404 -> register_consumer(user)
          _ -> raise KongClientServiceError, "unexpected status_code"
        end
      _ -> raise KongClientServiceError
    end
  end

  defp register_consumer(user) do
    case Kong.post("/consumers", {:form, [{:custom_id, user.id}, {:username, user.number}]}) do
      {:ok, res} ->
        case res.status_code do
          201 -> res.body
          _ -> raise KongClientServiceError, "unexpected status_code"
        end
      _ -> raise KongClientServiceError
    end
  end

  defp jwt(data) do
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
