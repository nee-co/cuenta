defmodule Cuenta.KongClientServiceError do
 defexception message: "kong connect error"
end

defmodule Cuenta.KongClientService do
  import Joken
  alias Cuenta.Kong
  alias Cuenta.KongClientServiceError

  def register_token(user_id, number) do
    id = consumer(user_id, number)["id"]
    case Kong.post("/consumers/#{id}/jwt", {:form, []}) do
      {:ok, res} ->
        case res.status_code do
          201 -> res.body |> jwt
          _ -> raise KongClientServiceError, "unexpected status_code"
        end
      _ -> raise KongClientServiceError
    end
  end

  defp consumer(user_id, number) do
    case Kong.get("/consumers/#{number}") do
      {:ok, res} ->
        case res.status_code do
          200 -> res.body
          404 -> register_consumer(user_id, number)
          _ -> raise KongClientServiceError, "unexpected status_code"
        end
      _ -> raise KongClientServiceError
    end
  end

  defp register_consumer(user_id, number) do
    case Kong.post("/consumers", {:form, [{:custom_id, user_id}, {:username, number}]}) do
      {:ok, res} ->
        case res.status_code do
          201 -> res.body
          _ -> raise KongClientServiceError, "unexpected status_code"
        end
      _ -> raise KongClientServiceError
    end
  end

  defp jwt(data) do
    %Joken.Token{}
    |> with_signer(hs256("secret"))
    |> with_claim("iss", data["key"])
    |> with_claim("exp", Timex.now |> Timex.shift(weeks: 1) |> Timex.to_unix)
    |> with_signer(hs256(data["secret"]))
    |> sign
    |> get_compact
  end
end
