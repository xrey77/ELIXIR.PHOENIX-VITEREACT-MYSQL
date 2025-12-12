defmodule ElixirMyql.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :fistname, :string
      add :lastname, :string
      add :email, :string
      add :mobile, :string
      add :username, :string
      add :password, :string
      add :roles, :string
      add :isactivated, :integer
      add :isblocked, :integer
      add :mailtoken, :integer
      add :userpic, :string
      add :secret, :text
      add :qrcodeurl, :text

      timestamps(type: :utc_datetime)
    end
  end
end
