defmodule ElixirMyql.ProdsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirMyql.Prods` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        alertstocks: 42,
        category: "some category",
        costprice: "120.5",
        criticalstocks: 42,
        descriptions: "some descriptions",
        productpicture: "some productpicture",
        qty: 42,
        saleprice: "120.5",
        sellprice: "120.5",
        unit: "some unit"
      })
      |> ElixirMyql.Prods.create_product()

    product
  end
end
