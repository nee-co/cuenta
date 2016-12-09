defmodule Cuenta.TokenController do
  use Cuenta.Web, :controller

  import Cuenta.AuthHelper, only: [authenticate: 2, current_user: 1]

  alias Cuenta.User
  alias Cuenta.KongClientService
  alias Cuenta.OlvidoClientService

  plug Cuenta.Plug.RequireLogin when action in ~w(refresh)a

  def create(conn, %{"number" => number, "password" => password}) do
    case authenticate(number, password) do
      {:ok, login_user} ->
        {token, expires_at} = KongClientService.register_token(login_user)
        render(conn, "token.json", token: token, expires_at: expires_at)
      :error ->
        send_resp(conn, 404, "")
    end
  end

  def random_question(conn, %{"number" => number}) do
    {id, message} = Repo.get_by!(User, number: String.downcase(number)) |> OlvidoClientService.random_question
    render(conn, "question.json", id: id, message: message)
  rescue
    Ecto.NoResultsError -> send_resp(conn, 404, "")
  end

  def challenge(conn, %{"number" => number, "id" => id, "answer" => answer, "password" => password}) do
    user = Repo.get_by!(User, number: String.downcase(number))

    case OlvidoClientService.check_question(id, answer) do
      {:ok, user_id} ->
        # NOTE: かなり異常系だけど念のため
        unless user.id == user_id do
          send_resp(conn, 500, "") |> halt
        end

        case User.changeset(user, %{password: password}) |> Repo.update do
          {:ok, _} ->
            {token, expires_at} = KongClientService.register_token(user)
            render(conn, "token.json", token: token, expires_at: expires_at)
          _ -> send_resp(conn, 500, "")
        end
      :error -> send_resp(conn, 422, "")
    end
  rescue
    Ecto.NoResultsError -> send_resp(conn, 404, "")
  end

  def refresh(conn, _params) do
    {token, expires_at} = KongClientService.register_token(current_user(conn))
    render(conn, "token.json", token: token, expires_at: expires_at)
  end
end
