defmodule Cuenta.UserControllerTest do
  use Cuenta.ConnCase

  alias Cuenta.User

  @valid_attrs %{college_id: 1, encrypted_password: "password", name: "Hanako Yamada", number: "G011A1111"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "#list valid", %{conn: conn} do
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "G011A1111"}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "G022B2222"}) |> Repo.insert!
    conn = get conn, user_path(conn, :list, user_ids: "#{user1.id} #{user2.id}")

    assert json_response(conn, 200)["users"] == [
      %{
        "user_id" => user1.id, "name" => user1.name,
        "number" => user1.number, "college_id" => user1.college_id
        },
      %{
        "user_id" => user2.id, "name" => user2.name,
        "number" => user2.number, "college_id" => user2.college_id
        }
    ]
  end

  test "#list not found", %{conn: conn} do
    conn = get conn, user_path(conn, :list, user_ids: 9999)

    assert conn.status == 404
  end

  test "#list invalid param", %{conn: conn} do
    conn = get conn, user_path(conn, :list)

    assert conn.status == 400
  end
end
