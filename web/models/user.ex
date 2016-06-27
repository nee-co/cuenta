defmodule Cuenta.User do
  use Cuenta.Web, :model

  schema "users" do
    field :name, :string
    field :number, :string
    field :encrypted_password, :string
    field :college_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :number, :crypted_password, :college_id])
    |> validate_required([:name, :number, :crypted_password, :college_id])
  end
end
