defmodule Cuenta.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :number, :string
      add :crypted_password, :string
      add :college_id, :integer

      timestamps()
    end

  end
end
