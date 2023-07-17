defmodule LiveViewStudio.Airports do
  def suggest(""), do: []

  def suggest(prefix) do
    Map.filter(list_airports(), fn {code, _} ->
      String.starts_with?(String.upcase(code), String.upcase(prefix))
    end)
  end

  def list_airports do
    %{
      "SFO" => "San Francisco",
      "LAX" => "Los Angeles",
      "JFK" => "New York",
      "GRU" => "São Paulo",
      "BLA" => "Bla City",
      "GRA" => "Grajau"
    }
  end
end
