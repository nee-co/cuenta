defmodule Cuenta.UserControllerTest do
  use Cuenta.ConnCase

  alias Cuenta.User
  alias Cuenta.College

  @valid_attrs %{college_id: 1, password: "password", name: "Hanako Yamada", number: "g011a1111", note: ""}
  @invalid_attrs %{}

  def user_format(user, college) do
    %{
      "id" => user.id, "name" => user.name, "number" => user.number |> String.upcase,
      "image" => Application.get_env(:cuenta, :static_image_url) <> college.default_image_path,
      "college" => %{"code" => college.code, "name" => college.name},
      "note" => user.note |> to_string
    }
  end

  setup %{conn: conn} do
    user = User.changeset(%User{}, %{@valid_attrs | number: "000000000"}) |> Repo.insert!
    {:ok, conn: conn |> put_req_header("accept", "application/json") |> put_req_header("x-consumer-custom-id", user.id |> to_string)}
  end
end
