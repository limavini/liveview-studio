defmodule LiveViewStudioWeb.SalesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    if connected?(socket) do
      # send message inside connect because it'a different process than the first reload
      :timer.send_interval(1000, self(), :refresh)
    end

    socket = refresh(socket)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Snappy Sales 📊</h1>
    <div class="sales flex flex-row items-center justify-between p-3 rounded-md border bg-gray-100">
      <div class="stats">
        <span><%= @new_orders %></span>
        <span>New Orders</span>
      </div>

      <div class="stats">
        <span><%= @sales_amount %></span>
        <span>Sales Amount</span>
      </div>

      <div class="stats">
        <span><%= @satisfaction %></span>
        <span>Satisfaction</span>
      </div>
    </div>

    <button phx-click="refresh" class="rounded p-2 bg-blue-200 mt-2 ">
      Refresh 🔄
    </button>
    """
  end

  def handle_event("refresh", _, socket) do
    socket = refresh(socket)
    {:noreply, socket}
  end

  def handle_info(:refresh, socket) do
    socket = refresh(socket)
    {:noreply, socket}
  end

  defp refresh(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
