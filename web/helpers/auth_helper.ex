defmodule Cuenta.AuthHelper do
  alias Cuenta.User
  alias Cuenta.Repo

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def authenticate(number, password) do
    user = Repo.get_by!(User, number: String.downcase(number)) |> Repo.preload(:college)
    case Comeonin.Bcrypt.checkpw(password, user.encrypted_password) do
      true -> {:ok, user}
      _ -> :error
    end
  rescue
    Ecto.NoResultsError -> :error
  end
end
