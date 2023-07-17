defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        airport: "",
        flights: LiveViewStudio.Flights.list_flights(),
        loading: false,
        matches: %{}
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-xl pb-2">Find a Flight 🛩</h1>
    <div id="flights">
      <form phx-submit="search" phx-change="suggest">
        <input
          class="rounded"
          type="text"
          name="airport"
          value={@airport}
          placeholder="Airport Code"
          autofocus
          autocomplete="off"
          readonly={@loading}
          list="matches"
          phx-debounce="300"
        />

        <button class="rounded border bg-blue-100 p-2">
          Search 🔎
        </button>
      </form>

      <datalist id="matches">
        <option :for={{code, name} <- @matches} value={code}><%= name %></option>
      </datalist>

      <div :if={@loading}>Loading...</div>

      <div :if={!@loading} class="flights">
        <ul class="space-y-2 mt-6">
          <!-- Servers sends <li> just one time, because client knows that it should repeat 6 times the same element-->
          <li :for={flight <- @flights} class="p-3 w-100 border rounded-md bg-gray-100">
            <%= flight.origin %> ➡️ <%= flight.destination %>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("suggest", %{"airport" => prefix}, socket) do
    matches = LiveViewStudio.Airports.suggest(prefix)
    socket = assign(socket, matches: matches)

    {:noreply, socket}
  end

  def handle_event("search", %{"airport" => ""}, socket) do
    socket =
      assign(socket,
        airport: "",
        flights: LiveViewStudio.Flights.list_flights()
      )

    {:noreply, socket}
  end

  def handle_event("search", %{"airport" => airport}, socket) do
    # Because we want to do this async and don't block the UI
    send(self(), {:run_search, airport})

    socket =
      assign(socket,
        airport: "",
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_search, airport}, socket) do
    socket =
      assign(socket,
        flights: LiveViewStudio.Flights.search_by_airport(airport),
        loading: false
      )

    {:noreply, socket}
  end
end
