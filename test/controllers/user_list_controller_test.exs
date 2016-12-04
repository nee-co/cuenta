defmodule Cuenta.UserListControllerTest do
  use Cuenta.ConnCase

  alias Cuenta.User
  alias Cuenta.College

  @valid_attrs %{college_id: 1, password: "password", name: "Hanako Yamada", number: "g011a1111", note: ""}
  @invalid_attrs %{}

  def user_format(user, college) do
    %{
      "id" => user.id, "name" => user.name, "number" => user.number |> String.upcase,
      "image" => Application.get_env(:cuenta, :static_image_url),
      "college" => %{"code" => college.code, "name" => college.name},
      "note" => user.note |> to_string
    }
  end

  setup %{conn: conn} do
    user = User.changeset(%User{}, %{@valid_attrs | number: "000000000"}) |> Repo.insert!
    {:ok, conn: conn |> put_req_header("accept", "application/json") |> put_req_header("x-consumer-custom-id", user.id |> to_string)}
  end

  test "#list / valid", %{conn: conn} do
    college1 = College |> Repo.get(1)
    college2 = College |> Repo.get(2)
    user1 = User.changeset(%User{}, %{@valid_attrs | number: "g011a1111", college_id: college1.id}) |> Repo.insert!
    user2 = User.changeset(%User{}, %{@valid_attrs | number: "g022b2222", college_id: college2.id}) |> Repo.insert!
    conn = get conn, user_list_path(conn, :list, user_ids: "#{user1.id} #{user2.id}")

    assert json_response(conn, 200)["users"] == [user_format(user1, college1), user_format(user2, college2)]
  end

  test "#list / valid / duplicate id", %{conn: conn} do
    college = College |> Repo.get(1)
    user = User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    conn = get conn, user_list_path(conn, :list, user_ids: "#{user.id} #{user.id} #{user.id}")

    assert json_response(conn, 200)["users"] == [user_format(user, college)]
  end

  test "#list / invalid / record not found", %{conn: conn} do
    conn = get conn, user_list_path(conn, :list, user_ids: 9999)

    assert conn.status == 404
  end

  test "#list / invalid / non numeric param", %{conn: conn} do
    conn = get conn, user_list_path(conn, :list, user_ids: "a")

    assert conn.status == 400
  end
end
