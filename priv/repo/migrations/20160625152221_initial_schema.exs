defmodule Cuenta.Repo.Migrations.InitialSchema do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :number, :string, size: 9
      add :crypted_password, :string
      add :college_id, :integer

      timestamps()
    end

  end
end
