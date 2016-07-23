if Cuenta.College |> Cuenta.Repo.all == [] do
  Cuenta.Repo.insert!(%Cuenta.College{id: 1, name: "クリエイター", code: "A"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 2, name: "ミュージック", code: "B"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 3, name: "IT", code: "C"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 4, name: "テクノロジー", code: "D"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 5, name: "医療・保育", code: "E"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 6, name: "スポーツ", code: "F"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 7, name: "デザイン", code: "G"})
end
