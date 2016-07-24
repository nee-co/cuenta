defmodule Cuenta.Repo.Migrations.InitialSchema do
  use Ecto.Migration

  def change do
    create table(:colleges) do
      add :name, :string, null: false
      add :code, :string, size: 1,  null: false, unique: true

      timestamps()
    end

    create table(:users) do
      add :name, :string, null: false
      add :number, :string, size: 9, null: false, unique: true
      add :encrypted_password, :string, null: false
      add :college_id, references(:colleges, on_delete: :nilify_all)

      timestamps()
    end
    create unique_index(:users, [:number])
  end
end
