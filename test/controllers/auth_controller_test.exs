defmodule Cuenta.AuthControllerTest do
  use Cuenta.ConnCase

  alias Cuenta.User
  alias Cuenta.College

  @valid_attrs %{college_id: 1, password: "password", name: "Hanako Yamada", number: "g011a1111"}
  @invalid_attrs %{}

  def user_format(user, college) do
    %{
      "id" => user.id, "name" => user.name, "number" => user.number |> String.upcase,
      "image" => Application.get_env(:cuenta, :static_url) <> college.default_image_path,
      "college" => %{"code" => college.code, "name" => college.name},
      "note" => user.note |> to_string
    }
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "#login / valid", %{conn: conn} do
    college = College |> Repo.get(1)
    user = User.changeset(%User{}, %{@valid_attrs | college_id: college.id}) |> Repo.insert!
    conn = post conn, auth_path(conn, :login, %{number: "g011a1111", password: "password"})

    assert json_response(conn, 200) == user_format(user, college)
  end

  test "#login / valid / upcase number", %{conn: conn} do
    college = College |> Repo.get(1)
    user = User.changeset(%User{}, %{@valid_attrs | college_id: college.id}) |> Repo.insert!
    conn = post conn, auth_path(conn, :login, %{number: "G011A1111", password: "password"})

    assert json_response(conn, 200) == user_format(user, college)
  end

  test "#login / invalid", %{conn: conn} do
    User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    conn = post conn, auth_path(conn, :login, %{number: "g011a1111", password: "invalid password"})

    assert conn.status == 404
  end
end
