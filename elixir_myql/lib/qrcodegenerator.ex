defmodule QRCodeGenerator do
  import QRCode, only: [create: 1, to_base64: 1]

  @spec generate_base64_qrcode(any()) :: none()
  def generate_base64_qrcode(data) do
    data
    |> create()
    |> case do
      {:ok, qr_matrix} ->
        case QRCode.render(qr_matrix, :png, module_pixel_size: 4) do
          {:ok, rendered_qr} ->
            base64_binary = to_base64(rendered_qr)
            base64_string = Base.encode64(base64_binary)
            IO.puts("BINARY......" <> base64_string)
            # base64_string = Base.decode64!(base64_string1)
            # IO.puts("BASE64:1....." <> base64_string)
            {:ok, base64_string}
          :error ->
            IO.puts("Render Failed............")
            {:error, "Render failed"}
        end
      :error ->
        IO.puts("Create Failed...........")
        {:error, "Create failed"}
    end
  end

end
