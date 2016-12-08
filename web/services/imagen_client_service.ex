defmodule Cuenta.ImagenClientService do
  alias Cuenta.Imagen

  def upload_image(image, image_name) do
    case Imagen.put("internal/images/#{image_name}", image_param(image)) do
      {:ok, res} ->
        case res.status_code do
          201 -> :ok
          _ -> {:unprocessable_entity, res.body["message"]}
        end
      _ -> :error
    end
  end

  defp image_param(image) do
    options = [{"name", "image"}, {"filename", image.filename}]
    headers = [{"Content-Type", image.content_type}]
    {:multipart, [{:file, image.path, {"form-data", options}, headers}]}
  end
end
