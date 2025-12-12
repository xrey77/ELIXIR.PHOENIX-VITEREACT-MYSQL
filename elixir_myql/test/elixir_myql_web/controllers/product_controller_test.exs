defmodule ElixirMyqlWeb.ProductControllerTest do
  use ElixirMyqlWeb.ConnCase

  import ElixirMyql.ProdsFixtures

  alias ElixirMyql.Prods.Product

  @create_attrs %{
    unit: "some unit",
    category: "some category",
    descriptions: "some descriptions",
    qty: 42,
    costprice: "120.5",
    sellprice: "120.5",
    saleprice: "120.5",
    productpicture: "some productpicture",
    alertstocks: 42,
    criticalstocks: 42
  }
  @update_attrs %{
    unit: "some updated unit",
    category: "some updated category",
    descriptions: "some updated descriptions",
    qty: 43,
    costprice: "456.7",
    sellprice: "456.7",
    saleprice: "456.7",
    productpicture: "some updated productpicture",
    alertstocks: 43,
    criticalstocks: 43
  }
  @invalid_attrs %{unit: nil, category: nil, descriptions: nil, qty: nil, costprice: nil, sellprice: nil, saleprice: nil, productpicture: nil, alertstocks: nil, criticalstocks: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, ~p"/api/products")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/products", product: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "alertstocks" => 42,
               "category" => "some category",
               "costprice" => "120.5",
               "criticalstocks" => 42,
               "descriptions" => "some descriptions",
               "productpicture" => "some productpicture",
               "qty" => 42,
               "saleprice" => "120.5",
               "sellprice" => "120.5",
               "unit" => "some unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/products", product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put(conn, ~p"/api/products/#{product}", product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "alertstocks" => 43,
               "category" => "some updated category",
               "costprice" => "456.7",
               "criticalstocks" => 43,
               "descriptions" => "some updated descriptions",
               "productpicture" => "some updated productpicture",
               "qty" => 43,
               "saleprice" => "456.7",
               "sellprice" => "456.7",
               "unit" => "some updated unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, ~p"/api/products/#{product}", product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, ~p"/api/products/#{product}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/products/#{product}")
      end
    end
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
