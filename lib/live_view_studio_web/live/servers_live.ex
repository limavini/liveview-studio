defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers

  def mount(_params, _session, socket) do
    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        selected_server: hd(servers),
        coffees: 0
      )

    {:ok, socket}
  end

  # Invoked after mount and before render
  def handle_params(%{"id" => id}, _uri, socket) do
    server = Servers.get_server!(id)

    # Adjusting also page title
    {:noreply, assign(socket, selected_server: server, page_title: server.name)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Server List 👾</h1>
    <div class="flex">
      <ul class="border rounded p-2">
        <li :for={server <- @servers} class={if server.id == @selected_server.id, do: "bg-red-500"}>
          <%!-- Use patch when you don't want to refresh the page and just call handle params --%>
          <.link patch={~p"/servers?#{[id: server]}"}>
            <%= server.name %>
            <%= server.id %>
          </.link>
        </li>
      </ul>
      <div class="p-2 rounded bg-gray-100">
        <h2>Server Details</h2>
        <ul>
          <li>Framework: <%= @selected_server.framework %></li>
          <li>Size: <%= @selected_server.size %></li>
          <li>Deploy Count: <%= @selected_server.deploy_count %></li>
          <li>Last Commit Message: <%= @selected_server.last_commit_message %></li>
          <li>Status: <%= @selected_server.status %></li>
        </ul>
      </div>
    </div>
    <h3 phx-click="drink">Coffees (click me): <%= @coffees %></h3>
    <%!-- Use navigate when you want to 'refresh' the page.
      The benefit over default href is that it only triggers mount once.
     --%>
    <.link navigate={~p"/light"}>
      Adjust Lights
    </.link>
    """
  end

  def handle_event("drink", _, socket) do
    {:noreply, update(socket, :coffees, &(&1 + 1))}
  end
end
