defmodule Sigil.ToInteger do
  def sigil_i(string, []) do
    String.split(string) |> Enum.map(&String.to_integer(&1)) |> Enum.uniq
  end
end
