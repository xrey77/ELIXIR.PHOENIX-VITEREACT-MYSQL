defmodule ElixirMyqlWeb.SearchController do
  use ElixirMyqlWeb, :controller
  alias ElixirMyql.Repo
  import Ecto.Query

  defp build_products_list(result) do
    columns = Enum.map(result.columns, &String.to_atom/1)

    Enum.map(result.rows, fn row ->
      Enum.zip(columns, row) |> Map.new()
    end)
  end

  def productSearch_api(conn, %{"page" => page, "keyword" => keyword}) do
    page_int = String.to_integer(page)

    search_term = "%"<>String.downcase(keyword)<>"%"

    count_query =
    from p in "products",
      where: like(p.descriptions, ^search_term),
      select: fragment("count(*)")

    totalrecords = Repo.one(count_query)
    perpage = 5
    offset = (page_int - 1) * perpage
    total1 = Float.ceil(totalrecords / perpage)
    totalpage = round(total1)

    query = "SELECT id, category, descriptions, qty, unit, costprice, sellprice, saleprice, productpicture, alertstocks, criticalstocks  FROM products WHERE LOWER(descriptions) LIKE ? ORDER BY id LIMIT ? OFFSET ?"
    case ElixirMyql.Repo.query(query, [search_term,perpage, offset]) do
      {:ok, result} ->
            products = build_products_list(result)

            if Enum.empty?(products) do

              res = %{ message: "No record(s) found." }
              conn |> put_status(:not_found) |> json(res)

            else
                res = %{
                  page: page,
                  totpage: totalpage,
                  totalrecords: totalrecords,
                  products: products
                }
                conn
                |> put_status(:ok)
                |> json(res)

          end
        end
    end
end
