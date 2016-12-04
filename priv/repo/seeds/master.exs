if Cuenta.College |> Cuenta.Repo.all == [] do
  Cuenta.Repo.insert!(%Cuenta.College{id: 1, name: "クリエイターズ", code: "a"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 2, name: "ミュージック", code: "b"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 3, name: "IT", code: "c"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 4, name: "テクノロジー", code: "d"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 5, name: "医療・保育", code: "e"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 6, name: "スポーツ", code: "f"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 7, name: "デザイン", code: "g"})
end
