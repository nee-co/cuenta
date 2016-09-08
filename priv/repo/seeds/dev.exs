import Faker.Name.Ja, only: [name: 0]
import Enum, only: [random: 1]
alias Cuenta.User
alias Cuenta.Repo

insert_user = fn (num) ->
  college_id = num + 1
  college_code = ~W/a b c d e f g/ |> Enum.at(num)
  year = random(0..20) |> Integer.to_string |> String.rjust(2, ?0)
  personal = random(0..9999) |> Integer.to_string |> String.rjust(4, ?0)
  number = "g0#{year}#{college_code}#{personal}"
  password = "#{number}password"

  User.changeset(%User{}, %{ name: name, number: number, college_id: college_id, password: password }) |> Repo.insert!
end

1..21 |> Enum.to_list |> Enum.each(&insert_user.(rem(&1, 7)))
