defmodule Cuenta.UserControllerTest do
  use Cuenta.ConnCase

  alias Cuenta.User
  alias Cuenta.College

  @valid_attrs %{college_id: 1, encrypted_password: "password", name: "Hanako Yamada", number: "G011A1111"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "#list / valid", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "G011A1111", college_id: college1.id}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "G022B2222", college_id: college2.id}) |> Repo.insert!
    conn = get conn, user_path(conn, :list, user_ids: "#{user1.id} #{user2.id}")

    assert json_response(conn, 200)["users"] == [
      %{
        "user_id" => user1.id, "name" => user1.name, "number" => user1.number,
        "college" => %{"code" => college1.code, "name" => college1.name}
        },
      %{
        "user_id" => user2.id, "name" => user2.name, "number" => user2.number,
        "college" => %{"code" => college2.code, "name" => college2.name}
        }
    ]
  end

  test "#list / valid / duplicate id", %{conn: conn} do
    college = College |> Repo.get(1)
    user = User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    conn = get conn, user_path(conn, :list, user_ids: "#{user.id} #{user.id} #{user.id}")

    assert json_response(conn, 200)["users"] == [
      %{
        "user_id" => user.id, "name" => user.name, "number" => user.number,
        "college" => %{"code" => college.code, "name" => college.name}
        }
    ]
  end

  test "#list / invalid / record not found", %{conn: conn} do
    conn = get conn, user_path(conn, :list, user_ids: 9999)

    assert conn.status == 404
  end

  test "#list / invalid / no param", %{conn: conn} do
    conn = get conn, user_path(conn, :list)

    assert conn.status == 400
  end

  test "#list / invalid / non numeric param", %{conn: conn} do
    conn = get conn, user_path(conn, :list, user_ids: "a")

    assert conn.status == 400
  end

  test "#search / valid", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "G011A1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "G022B2222", college_id: college2.id, name: "田中"}) |> Repo.insert!

    # context: multi hit
    conn = get conn, user_path(conn, :search, name: "田")
    assert json_response(conn, 200)["total_count"] == 2
    assert json_response(conn, 200)["users"] == [
      %{
        "user_id" => user1.id, "name" => user1.name, "number" => user1.number,
        "college" => %{"code" => college1.code, "name" => college1.name}
        },
      %{
        "user_id" => user2.id, "name" => user2.name, "number" => user2.number,
        "college" => %{"code" => college2.code, "name" => college2.name}
        }
    ]

    # context: only hit
    conn = get conn, user_path(conn, :search, name: "山田")
    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [
      %{
        "user_id" => user1.id, "name" => user1.name, "number" => user1.number,
        "college" => %{"code" => college1.code, "name" => college1.name}
        }
    ]
  end

  test "#search / valid / in_user", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "G011A1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    User.changeset(%User{}, %{@valid_attrs | number: "G022B2222", college_id: college2.id, name: "田中"}) |> Repo.insert!
    conn = get conn, user_path(conn, :search, name: "田", user_ids: user1.id)

    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [
      %{
        "user_id" => user1.id, "name" => user1.name, "number" => user1.number,
        "college" => %{"code" => college1.code, "name" => college1.name}
        }
    ]
  end

  test "#search / valid / in_college", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    User.changeset(%User{}, %{@valid_attrs | number: "G011A1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "G022B2222", college_id: college2.id, name: "田中"}) |> Repo.insert!
    conn = get conn, user_path(conn, :search, name: "田", college_ids: college2.id)

    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [
      %{
        "user_id" => user2.id, "name" => user2.name, "number" => user2.number,
        "college" => %{"code" => college2.code, "name" => college2.name}
        }
    ]
  end

  test "#search / deprocated / in_user & in_college", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "G011A1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    User.changeset(%User{}, %{@valid_attrs | number: "G022B2222", college_id: college2.id, name: "田中"}) |> Repo.insert!
    conn = get conn, user_path(conn, :search, name: "田", user_ids: user1.id, college: college2.id)

    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [
      %{
        "user_id" => user1.id, "name" => user1.name, "number" => user1.number,
        "college" => %{"code" => college1.code, "name" => college1.name}
        }
    ]
  end

  test "#search / invalid / no param", %{conn: conn} do
    conn = get conn, user_path(conn, :search)

    assert conn.status == 400
  end

  test "#search / invalid / non numeric param", %{conn: conn} do
    # context: non numeric user_ids
    conn = get conn, user_path(conn, :search, name: "test", user_ids: "string")
    assert conn.status == 400

    # context: non numeric college_ids
    conn = get conn, user_path(conn, :search, name: "test", college_ids: "string")
    assert conn.status == 400
  end
end
