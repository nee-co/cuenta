defmodule Cuenta.KongError do
 defexception message: "kong url has not been set"
end

defmodule Cuenta.Kong do
  use HTTPoison.Base
  alias Cuenta.KongError

  def process_url(url) do
    unless Application.get_env(:cuenta, :kong_url) do
      raise KongError
    end
    Path.join(Application.get_env(:cuenta, :kong_url), url)
  end

  def process_response_body(body) do
    body |> Poison.decode!
  end
end
