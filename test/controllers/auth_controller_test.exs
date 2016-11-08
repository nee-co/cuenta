defmodule Cuenta.AuthControllerTest do
  use Cuenta.ConnCase

  alias Cuenta.User

  @valid_attrs %{college_id: 1, password: "password", name: "Hanako Yamada", number: "g011a1111"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "#login / valid", %{conn: conn} do
    user = User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    conn = post conn, auth_path(conn, :login, %{number: "g011a1111", password: "password"})

    assert json_response(conn, 200) == %{
        "user_id" => user.id, "name" => "Hanako Yamada", "number" => "g011a1111",
        "college" => %{"code" => "a", "name" => "クリエイターズ"}
      }
  end

  test "#login / valid / upcase number", %{conn: conn} do
    user = User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    conn = post conn, auth_path(conn, :login, %{number: "G011A1111", password: "password"})

    assert json_response(conn, 200) == %{
        "user_id" => user.id, "name" => "Hanako Yamada", "number" => "g011a1111",
        "college" => %{"code" => "a", "name" => "クリエイターズ"}
      }
  end

  test "#login / invalid", %{conn: conn} do
    User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    conn = post conn, auth_path(conn, :login, %{number: "g011a1111", password: "invalid password"})

    assert conn.status == 404
  end
end
