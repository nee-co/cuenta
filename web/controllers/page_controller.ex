defmodule Cuenta.PageController do
  use Cuenta.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
