defmodule Cuenta.User do
  use Cuenta.Web, :model

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  alias Cuenta.Repo
  alias Cuenta.College

  schema "users" do
    field :name, :string
    field :number, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :image_path, :string
    field :note, :string

    timestamps()

    belongs_to :college, Cuenta.College
  end

  @required_fields ~w(name number encrypted_password college_id image_path)a
  @permit_fields @required_fields ++ ~w(password note)a

  def like_name_or_number(query, str) do
    query |> where([u], like(u.name, ^"%#{str}%") or like(u.number, ^"%#{String.downcase(str)}%"))
  end

  def in_college(query, college_codes) do
    query
    |> join(:inner, [u], c in assoc(u, :college))
    |> where([_u, c], c.code in ^college_codes)
  end

  def in_user(query, user_ids) do
    query |> where([u], u.id in ^user_ids)
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @permit_fields)
    |> set_default_image(user.image_path)
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

  defp set_default_image(changeset, image_path) do
    if image_path == nil && get_change(changeset, :image_path) == nil do
      college = Repo.get!(College, get_change(changeset, :college_id))
      put_change(changeset, :image_path, college.default_image_path)
    else
      changeset
    end
  end
end
