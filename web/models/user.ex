defmodule Cuenta.User do
  use Cuenta.Web, :model

  schema "users" do
    field :name, :string
    field :number, :string
    field :encrypted_password, :string

    timestamps()

    belongs_to :college, Cuenta.College
  end

  def like_name(query, name) do
    query |> where([u], like(u.name, ^"%#{name}%"))
  end

  def in_college(query, college_ids) do
    query |> where([u], u.college_id in ^college_ids)
  end

  def in_user(query, user_ids) do
    query |> where([u], u.id in ^user_ids)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :number, :encrypted_password, :college_id])
    |> validate_required([:name, :number, :encrypted_password, :college_id])
  end
end
