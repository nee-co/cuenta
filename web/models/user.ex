defmodule Cuenta.User do
  use Cuenta.Web, :model

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :name, :string
    field :number, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :image, :string
    field :note, :string

    timestamps()

    belongs_to :college, Cuenta.College
  end

  @required_fields ~w(name number encrypted_password college_id)a
  @permit_fields @required_fields ++ ~w(password note)a

  def like_name(query, name) do
    query |> where([u], like(u.name, ^"%#{name}%"))
  end

  def like_number(query, number) do
    query |> where([u], like(u.number, ^"%#{String.downcase(number)}%"))
  end

  def in_college(query, college_codes) do
    query
    |> join(:inner, [u], c in assoc(u, :college))
    |> where([_u, c], c.code in ^college_codes)
  end

  def in_user(query, user_ids) do
    query |> where([u], u.id in ^user_ids)
  end

  def not_in_user(query, user_ids) do
    query |> where([u], not(u.id in ^user_ids))
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @permit_fields)
    |> hash_password
    |> validate_required(@required_fields)
    |> validate_length(:number, is: 9)
    |> validate_length(:password, min: 8)
    |> update_change(:number, &String.downcase/1)
    |> unique_constraint(:number, message: "duplicate number")
    |> assoc_constraint(:college)
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
        nil      -> changeset
        password -> put_change(changeset, :encrypted_password, hashpwsalt(password))
    end
  end
end
