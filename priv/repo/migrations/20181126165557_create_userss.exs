defmodule MyApp.Repo.Migrations.CreateUserss do
  use Ecto.Migration

  def change do
    create table(:userss) do
      add :email, :string, null: false
      add :password_hash, :string
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:userss, [:email])
  end
end
