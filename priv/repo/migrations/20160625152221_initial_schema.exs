defmodule Cuenta.Repo.Migrations.InitialSchema do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :number, :string, size: 9, null: false, unique: true
      add :encrypted_password, :string, null: false
      add :college_id, :integer, null: false

      timestamps()
    end

    create unique_index(:users, [:number], name: :unique_number)
  end
end
