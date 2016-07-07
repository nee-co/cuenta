# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cuenta.Repo.insert!(%Cuenta.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

#TODO: 環境ごとにseedを分ける
if Cuenta.College |> Cuenta.Repo.all == [] do
  Cuenta.Repo.insert!(%Cuenta.College{id: 1, name: "クリエイター", code: "A"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 2, name: "ミュージック", code: "B"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 3, name: "IT", code: "C"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 4, name: "テクノロジー", code: "D"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 5, name: "医療・保育", code: "E"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 6, name: "スポーツ", code: "F"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 7, name: "デザイン", code: "G"})
end
