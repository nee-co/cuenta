defmodule Cuenta.OlvidoError do
 defexception message: "olvido url has not been set"
end

defmodule Cuenta.Olvido do
  use HTTPoison.Base
  alias Cuenta.OlvidoError

  def process_url(url) do
    unless Application.get_env(:cuenta, :olvido_url) do
      raise OlvidoError
    end
    Path.join(Application.get_env(:cuenta, :olvido_url), url)
  end

  def process_response_body(body) do
    body |> Poison.decode!
  end
end
