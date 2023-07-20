defmodule LiveViewStudioWeb.BoatsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Boats
  alias LiveViewStudioWeb.CustomComponents

  def mount(_params, _session, socket) do
    # Using temporary_assigns because we want to save memory and not store the list of boats in the socket

    {:ok, assign(socket, boats: Boats.list_boats(), filter: %{type: "", prices: []}),
     temporary_assigns: [boats: []]}
  end

  def render(assigns) do
    ~H"""
    <h1>Daily Boat Rentals</h1>
    <CustomComponents.promo>
      Hurry! Limited time offer!
      <:legal>
        Offer valid until <%= Date.utc_today() %>
      </:legal>
    </CustomComponents.promo>

    <div id="boats">
      <.filter_form filter={@filter} />

      <div class="flex justify-between flex-wrap space-x-1"></div>
      <.boat :for={boat <- @boats} boat={boat} />
      <CustomComponents.promo expires_in={1}>
        <a href="#">Contact us</a>
        for more information.
        <:legal>
          Don't miss out!
        </:legal>
        <%!-- https://hexdocs.pm/heroicons/Heroicons.html --%>
        <.icon name="hero-exclamation-circle" />
      </CustomComponents.promo>
    </div>
    """
  end

  attr :boat, LiveViewStudio.Boats.Boat, required: true

  def boat(assigns) do
    ~H"""
    <div class="w-1/4">
      <img src={@boat.image} />
      <div class="content">
        <div class="model">
          <%= @boat.model %>
        </div>
        <div class="details">
          <span class="price">
            <%= @boat.price %>
          </span>
          <span class="type">
            <%= @boat.type %>
          </span>
        </div>
      </div>
    </div>
    """
  end

  attr :filter, :map, required: true

  def filter_form(assigns) do
    ~H"""
    <form phx-change="filter">
      <div class="filters">
        <select name="type">
          <%= Phoenix.HTML.Form.options_for_select(
            type_options(),
            @filter.type
          ) %>
        </select>
        <div class="prices">
          <%= for price <- ["$", "$$", "$$$"] do %>
            <input
              type="checkbox"
              name="prices[]"
              value={price}
              id={price}
              checked={price in @filter.prices}
            />
            <label for={price}><%= price %></label>
          <% end %>
          <input type="hidden" name="prices[]" value="" />
        </div>
      </div>
    </form>
    """
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    boats = Boats.list_boats(%{type: type, prices: prices})

    socket = assign(socket, boats: boats, filter: %{type: type, prices: prices})
    {:noreply, socket}
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end
end
