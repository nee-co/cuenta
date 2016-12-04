defmodule Cuenta.ImagenError do
 defexception message: "imagen url has not been set"
end

defmodule Cuenta.Imagen do
  use HTTPoison.Base
  alias Cuenta.ImagenError

  def process_url(url) do
    unless Application.get_env(:cuenta, :imagen_url) do
      raise ImagenError
    end
    Path.join(Application.get_env(:cuenta, :imagen_url), url)
  end

  def process_response_body(body) do
    body |> Poison.decode!
  end
end
