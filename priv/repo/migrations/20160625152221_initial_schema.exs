defmodule Cuenta.Repo.Migrations.InitialSchema do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :number, :string, size: 9, null: false
      add :encrypted_password, :string, null: false
      add :college_id, :integer, null: false

      timestamps()
    end

  end
end
