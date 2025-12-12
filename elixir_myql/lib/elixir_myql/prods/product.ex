defmodule ElixirMyql.Prods.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :unit, :string
    field :category, :string
    field :descriptions, :string
    field :qty, :integer
    field :costprice, :decimal
    field :sellprice, :decimal
    field :saleprice, :decimal
    field :productpicture, :string
    field :alertstocks, :integer
    field :criticalstocks, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:category, :descriptions, :qty, :unit, :costprice, :sellprice, :saleprice, :productpicture, :alertstocks, :criticalstocks])
    |> validate_required([:category, :descriptions, :qty, :unit, :costprice, :sellprice, :saleprice, :productpicture, :alertstocks, :criticalstocks])
  end
end
