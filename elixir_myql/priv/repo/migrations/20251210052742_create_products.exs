defmodule ElixirMyql.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :category, :string
      add :descriptions, :string
      add :qty, :integer
      add :unit, :string
      add :costprice, :decimal
      add :sellprice, :decimal
      add :saleprice, :decimal
      add :productpicture, :string
      add :alertstocks, :integer
      add :criticalstocks, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
