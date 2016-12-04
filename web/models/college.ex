defmodule Cuenta.College do
  use Cuenta.Web, :model

  schema "colleges" do
    field :name, :string
    field :code, :string

    timestamps()

    has_many :users, Cuenta.User
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :code])
    |> validate_required([:name, :code])
  end
end
