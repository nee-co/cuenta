defmodule Cuenta.OlvidoClientServiceError do
 defexception message: "olvido connect error"
end

defmodule Cuenta.OlvidoClientService do
  alias Cuenta.Olvido
  alias Cuenta.OlvidoClientServiceError

  def random_question(user) do
    case Olvido.get("/internal/questions", [], params: %{user_id: user.id}) do
      {:ok, res} ->
        case res.status_code do
          200 -> {res.body["id"], res.body["message"]}
          _ -> raise OlvidoClientServiceError, "unexpected status_code"
        end
      _ -> raise OlvidoClientServiceError
    end
  end

  def check_question(id, answer) do
    case Olvido.post("/internal/questions/#{id}", {:form, [{:answer, answer}]}) do
      {:ok, res} ->
        case res.status_code do
          200 -> {:ok, res.body["id"]}
          _ -> :error
        end
      _ -> raise OlvidoClientServiceError
    end
  end
end
