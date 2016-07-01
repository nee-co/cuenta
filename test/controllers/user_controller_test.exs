defmodule Cuenta.UserControllerTest do
  use Cuenta.ConnCase

  alias Cuenta.User
  @valid_attrs %{college_id: 42, encrypted_password: "some content", name: "some content", number: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
end
