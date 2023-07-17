defmodule LiveViewStudio.Flights do
  def search_by_airport(airport) do
    Process.sleep(4_000)

    list_flights()
    |> Enum.filter(
      &(&1.origin == String.upcase(airport) || &1.destination == String.upcase(airport))
    )
  end

  def list_flights do
    [
      %{
        origin: "SFO",
        destination: "LAX",
        airline: "United",
        flight_number: "UA 123",
        departure_time: "10:00 AM",
        arrival_time: "11:00 AM",
        duration: "1h"
      },
      %{
        origin: "SFO",
        destination: "LAX",
        airline: "Delta",
        flight_number: "DL 456",
        departure_time: "11:00 AM",
        arrival_time: "12:00 PM",
        duration: "1h"
      },
      %{
        origin: "GRU",
        destination: "JFK",
        airline: "Southwest",
        flight_number: "SW 789",
        departure_time: "12:00 PM",
        arrival_time: "1:00 PM",
        duration: "1h"
      },
      %{
        origin: "GRU",
        destination: "LAX",
        airline: "American",
        flight_number: "AA 101",
        departure_time: "1:00 PM",
        arrival_time: "2:00 PM",
        duration: "1h"
      }
    ]
  end
end
