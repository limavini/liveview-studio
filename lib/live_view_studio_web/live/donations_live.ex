defmodule LiveViewStudioWeb.DonationsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [donations: []]}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-4xl">Donations</h1>
    <form phx-change="change-per-page">
      <select name="per_page">
        <%= Phoenix.HTML.Form.options_for_select([5, 10, 25, 50], @options.per_page) %>
        <label for="per-page">Per page</label>
      </select>
    </form>
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
    <div>
      <.link :if={@options.page > 1} patch={~p"/donations?#{%{@options | page: @options.page - 1}}"}>
        Previous
      </.link>
      <.link patch={~p"/donations?#{%{@options | page: @options.page + 1}}"}>
        Next
      </.link>
    </div>
    """
  end

  def handle_event("change-per-page", %{"per_page" => per_page}, socket) do
    options = %{socket.assigns.options | per_page: String.to_integer(per_page)}

    {:noreply, push_patch(socket, to: ~p"/donations?#{options}")}
  end

  def handle_params(params, _uri, socket) do
    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()
    page = (params["page"] || "1") |> String.to_integer()
    per_page = (params["per_page"] || "5") |> String.to_integer()

    options = %{sort_by: sort_by, sort_order: sort_order, per_page: per_page, page: page}
    donations = Donations.list_donations(options)
    socket = assign(socket, donations: donations, options: options)

    {:noreply, socket}
  end

  attr :sort_by, :atom, required: true
  attr :options, :map, required: true
  slot :inner_block, required: true

  defp sort_link(assigns) do
    params = %{
      assigns.options
      | sort_by: assigns.sort_by,
        sort_order: next_sort_order(assigns.options.sort_order)
    }

    assigns = assign(assigns, params: params)

    ~H"""
    <.link patch={~p"/donations?#{@params}"}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  defp next_sort_order(sort_order) do
    case sort_order do
      :asc -> :desc
      :desc -> :asc
    end
  end
end
