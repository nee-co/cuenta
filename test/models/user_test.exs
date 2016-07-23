defmodule Cuenta.UserTest do
  use Cuenta.ModelCase

  alias Cuenta.User

  @valid_attrs %{college_id: 1, password: "12345678", name: "example_name", number: "g011a1234"}

  test "changeset / valid" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset / valid / format / number / upcase" do
    changeset = User.changeset(%User{}, %{@valid_attrs | number: "G011A1111"})
    assert changeset.valid?
  end

  test "changeset / invalid / required / college_id" do
    changeset = User.changeset(%User{}, @valid_attrs |> Map.delete(:college_id))
    refute changeset.valid?
  end

  test "changeset / invalid / required / password" do
    changeset = User.changeset(%User{}, @valid_attrs |> Map.delete(:password))
    refute changeset.valid?
  end

  test "changeset / invalid / required / name" do
    changeset = User.changeset(%User{}, @valid_attrs |> Map.delete(:name))
    refute changeset.valid?
  end

  test "changeset / invalid / required / number" do
    changeset = User.changeset(%User{}, @valid_attrs |> Map.delete(:number))
    refute changeset.valid?
  end

  test "changeset / invalid / format / password / min 8" do
    changeset = User.changeset(%User{}, %{@valid_attrs | password: "1234567"})
    refute changeset.valid?
  end

  test "changeset / invalid / format / number / 9" do
    changeset = User.changeset(%User{}, %{@valid_attrs | number: "g011a12345"})
    refute changeset.valid?
  end

  test "changeset / invalid / unique / number" do
    User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    {:error, changeset} = User.changeset(%User{}, @valid_attrs) |> Repo.insert
    refute changeset.valid?
    assert changeset.errors[:number] == {"duplicate number", []}
  end

end
