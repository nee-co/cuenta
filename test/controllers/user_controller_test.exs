defmodule Cuenta.UserControllerTest do
  use Cuenta.ConnCase

  alias Cuenta.User
  alias Cuenta.College

  @valid_attrs %{college_id: 1, password: "password", name: "Hanako Yamada", number: "g011a1111", note: ""}
  @invalid_attrs %{}

  def user_format(user, college) do
    %{
      "user_id" => user.id, "name" => user.name, "number" => user.number |> String.upcase,
      "user_image" => Application.get_env(:cuenta, :image_url) <> college.default_image_path,
      "college" => %{"code" => college.code, "name" => college.name},
      "note" => user.note |> to_string
    }
  end

  setup %{conn: conn} do
    user = User.changeset(%User{}, %{@valid_attrs | number: "000000000"}) |> Repo.insert!
    {:ok, conn: conn |> put_req_header("accept", "application/json") |> put_req_header("x-consumer-custom-id", user.id |> to_string)}
  end

  test "#show / valid", %{conn: conn} do
    college = College |> Repo.get(1)
    user = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college.id}) |> Repo.insert!
    conn = get conn, user_path(conn, :show, user)

    assert json_response(conn, 200) == user_format(user, college)
  end

  test "#show / invalid / record not found", %{conn: conn} do
    conn = get conn, user_path(conn, :show, 0)

    assert conn.status == 404
  end

  test "#list / valid", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id}) |> Repo.insert!
    conn = get conn, user_path(conn, :list, user_ids: "#{user1.id} #{user2.id}")

    assert json_response(conn, 200)["users"] == [user_format(user1, college1), user_format(user2, college2)]
  end

  test "#list / valid / duplicate id", %{conn: conn} do
    college = College |> Repo.get(1)
    user = User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    conn = get conn, user_path(conn, :list, user_ids: "#{user.id} #{user.id} #{user.id}")

    assert json_response(conn, 200)["users"] == [user_format(user, college)]
  end

  test "#list / invalid / record not found", %{conn: conn} do
    conn = get conn, user_path(conn, :list, user_ids: 9999)

    assert conn.status == 404
  end

  test "#list / invalid / non numeric param", %{conn: conn} do
    conn = get conn, user_path(conn, :list, user_ids: "a")

    assert conn.status == 400
  end

  test "#search / valid / name / multi hit", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id, name: "田中"}) |> Repo.insert!

    conn = get conn, user_path(conn, :search, str: "田")
    assert json_response(conn, 200)["total_count"] == 2
    assert json_response(conn, 200)["users"] == [user_format(user1, college1), user_format(user2, college2)]
  end

  test "#search / valid / name / multi hit / except", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id, name: "田中"}) |> Repo.insert!

    conn = get conn, user_path(conn, :search, str: "田", except_ids: user2.id)
    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [user_format(user1, college1)]
  end

  test "#search / valid / name / only hit", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id, name: "田中"}) |> Repo.insert!

    conn = get conn, user_path(conn, :search, str: "山田")
    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [user_format(user1, college1)]
  end

  test "#search / valid / number / multi hit", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id, name: "田中"}) |> Repo.insert!

    conn = get conn, user_path(conn, :search, str: "g0")
    assert json_response(conn, 200)["total_count"] == 2
    assert json_response(conn, 200)["users"] == [user_format(user1, college1), user_format(user2, college2)]
  end

  test "#search / valid / number / multi hit / except", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id, name: "田中"}) |> Repo.insert!

    conn = get conn, user_path(conn, :search, str: "g0", except_ids: user2.id)
    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [user_format(user1, college1)]
  end

  test "#search / valid / number / only hit", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id, name: "田中"}) |> Repo.insert!

    conn = get conn, user_path(conn, :search, str: "g011")
    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [user_format(user1, college1)]
  end

  test "#search / valid / in_user", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id, name: "田中"}) |> Repo.insert!
    conn = get conn, user_path(conn, :search, str: "田", user_ids: user1.id)

    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [user_format(user1, college1)]
  end

  test "#search / valid / in_college", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id, name: "田中"}) |> Repo.insert!
    conn = get conn, user_path(conn, :search, str: "田", college_codes: college2.code)

    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [user_format(user2, college2)]
  end

  test "#search / deprecated / in_college / upcase", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id, name: "田中"}) |> Repo.insert!
    conn = get conn, user_path(conn, :search, str: "田", college_codes: String.upcase(college2.code))

    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [user_format(user2, college2)]
  end

  test "#search / deprecated / in_user & in_college", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id, name: "山田"}) |> Repo.insert!
    User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id, name: "田中"}) |> Repo.insert!
    conn = get conn, user_path(conn, :search, str: "田", user_ids: user1.id, college_codes: college2.code)

    assert json_response(conn, 200)["total_count"] == 1
    assert json_response(conn, 200)["users"] == [user_format(user1, college1)]
  end

  test "#search / invalid / no param", %{conn: conn} do
    conn = get conn, user_path(conn, :search)

    assert conn.status == 400
  end

  test "#search / invalid / non numeric param / user_ids", %{conn: conn} do
    conn = get conn, user_path(conn, :search, name: "test", user_ids: "string")
    assert conn.status == 400
  end

  test "#search / invalid / non numeric param / college_ids", %{conn: conn} do
    conn = get conn, user_path(conn, :search, name: "test", college_ids: "string")
    assert conn.status == 400
  end
end
