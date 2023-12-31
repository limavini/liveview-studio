defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  # mount
  def mount(_params, _session, socket) do
    brightness = 10

    socket =
      socket
      |> assign(brightness: brightness)

    {:ok, socket}
  end

  # render
  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light" phx-window-keyup="update-temp">
      <div class="meter w-full bg-sky-200 rounded">
        <span style={"width: #{@brightness}%"} class="bg-amber-400 p-2 text-center h-full block">
          <%= @brightness %>
        </span>
      </div>

      <div class="flex items-center justify-center my-2 space-x-5 flex-row">
        <button class="border rounded p-1" phx-click="off">OFF 🌑</button>
        <button class="border rounded p-1" phx-click="down">DOWN ⬇️</button>
        <button class="border rounded p-1" phx-click="random">RANDOM ❓</button>
        <button class="border rounded p-1" phx-click="up">UP ⬆️</button>
        <button class="border rounded p-1" phx-click="on">ON 💡</button>
      </div>

      <form phx-change="update">
        <input type="range" min="0" max="100" name="brightness" value={@brightness} />
      </form>
    </div>
    """
  end

  def handle_event("update-temp", %{"key" => "ArrowUp"}, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))
    {:noreply, socket}
  end

  def handle_event("update-temp", %{"key" => "ArrowDown"}, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    {:noreply, socket}
  end

  def handle_event("update-temp", _, socket) do
    {:noreply, socket}
  end

  def handle_event("update", params, socket) do
    socket = assign(socket, brightness: String.to_integer(params["brightness"]))
    {:noreply, socket}
  end

  # handle_event
  def handle_event("random", _, socket) do
    socket = assign(socket, brightness: Enum.random(0..100))
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, brightness: 0)
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))

    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))

    {:noreply, socket}
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, brightness: 100)
    {:noreply, socket}
  end
end
