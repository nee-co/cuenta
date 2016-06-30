defmodule Cuenta.UserTest do
  use Cuenta.ModelCase

  alias Cuenta.User

  @valid_attrs %{college_id: 42, crypted_password: "some content", name: "some content", number: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
