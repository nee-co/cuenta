defmodule Cuenta.College do
  use Cuenta.Web, :model

  schema "colleges" do
    field :name, :string
    field :code, :string
    field :default_image_path, :string

    timestamps()

    has_many :users, Cuenta.User
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :code, :default_image_path])
    |> validate_required([:name, :code, :default_image_path])
  end
end
