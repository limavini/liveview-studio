defmodule LiveViewStudioWeb.DonationsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [donations: []]}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-4xl">Donations</h1>
    <div class="table w-full border rounded-lg">
      <div class="table-header-group bg-purple-300">
        <div class="table-row">
          <div class="table-cell text-left">
            <.sort_link sort_by={:id} options={@options}>
              ID
            </.sort_link>
          </div>
          <div class="table-cell text-left">
            <.sort_link sort_by={:item} options={@options}>
              Item
            </.sort_link>
          </div>
          <div class="table-cell text-left">
            <.sort_link sort_by={:quantity} options={@options}>
              Quantity
            </.sort_link>
          </div>
          <div class="table-cell text-left">
            <.sort_link sort_by={:days_until_expires} options={@options}>
              Days Until Expires
            </.sort_link>
          </div>
        </div>
      </div>
      <div class="table-row-group">
        <%= for donation <- @donations do %>
          <div class="table-row">
            <div class="table-cell"><%= donation.id %></div>
            <div class="table-cell">
              <span><%= donation.item %></span> <span><%= donation.emoji %></span>
            </div>
            <div class="table-cell"><%= donation.quantity %></div>
            <div class={"table-cell #{if donation.days_until_expires < 10, do: "text-red-600"}"}>
              <%= donation.days_until_expires %>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  attr :sort_by, :atom, required: true
  attr :options, :map, required: true
  slot :inner_block, required: true

  defp sort_link(assigns) do
    ~H"""
    <.link patch={
      ~p"/donations?#{%{sort_by: @sort_by, sort_order: next_sort_order(@options.sort_order)}}"
    }>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def handle_params(params, _uri, socket) do
    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    options = %{sort_by: sort_by, sort_order: sort_order}
    donations = Donations.list_donations(options)
    socket = assign(socket, donations: donations, options: options)

    {:noreply, socket}
  end

  defp next_sort_order(sort_order) do
    case sort_order do
      :asc -> :desc
      :desc -> :asc
    end
  end
end
