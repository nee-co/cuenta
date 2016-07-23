import Faker.Name.Ja, only: [name: 0]
import Enum, only: [random: 1]

insert_user = fn (num) ->
  college_id = num + 1
  college_code = ~W/A B C D E F G/ |> Enum.at(num)
  year = random(0..20) |> Integer.to_string |> String.rjust(2, ?0)
  personal = random(0..9999) |> Integer.to_string |> String.rjust(4, ?0)
  number = "G0#{year}#{college_code}#{personal}"

  Cuenta.Repo.insert!(%Cuenta.User{name: name, number: number, college_id: college_id})
end

1..70 |> Enum.to_list |> Enum.each(&insert_user.(rem(&1, 7)))
