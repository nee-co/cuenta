if Cuenta.College |> Cuenta.Repo.all == [] do
  Cuenta.Repo.insert!(%Cuenta.College{id: 1, name: "クリエイターズ", code: "a", default_image_path: "/images/users/defaults/creators.png"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 2, name: "ミュージック", code: "b", default_image_path: "/images/users/defaults/music.png"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 3, name: "IT", code: "c", default_image_path: "/images/users/defaults/it.png"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 4, name: "テクノロジー", code: "d", default_image_path: "/images/users/defaults/technology.png"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 5, name: "医療・保育", code: "e", default_image_path: "/images/users/defaults/medical_childcare.png"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 6, name: "スポーツ", code: "f", default_image_path: "/images/users/defaults/sports.png"})
  Cuenta.Repo.insert!(%Cuenta.College{id: 7, name: "デザイン", code: "g", default_image_path: "/images/users/defaults/design.png"})
end
