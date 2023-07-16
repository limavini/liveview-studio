defmodule LiveViewStudioWeb.SandboxLive do
  use LiveViewStudioWeb, :live_view
  import Number.Currency
  alias LiveViewStudio.Sandbox

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(length: "0", width: "0", depth: "0", weight: 0.0, price: nil)

    {:ok, socket}
  end

  def handle_event("calculate", params, socket) do
    %{"length" => l, "width" => w, "depth" => d} = params
    weight = Sandbox.calculate(l, w, d)
    socket = assign(socket, weight: weight, length: l, width: w, depth: d, price: nil)
    {:noreply, socket}
  end

  def handle_event("get-quote", _, socket) do
    price = Sandbox.calculate_price(socket.assigns.weight)
    socket = assign(socket, price: price)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Build A Sandbox</h1>

    <div id="sandbox">
      <form
        phx-change="calculate"
        phx-submit="get-quote"
        class="flex flex-col justify-center items-center border p-6 rounded-md bg-gray-50"
      >
        <div class="fields flex flex-row justify-center">
          <div>
            <label for="length">Length</label>
            <input type="number" name="length" id="length" value={@length} />
          </div>
          <div>
            <label for="width">Width</label>
            <input type="number" name="width" id="width" value={@width} />
          </div>
          <div>
            <label for="depth">Depth</label>
            <input type="number" name="depth" id="depth" value={@depth} />
          </div>
        </div>

        <div class="weight mt-6 ">
          You need <%= @weight %> pounds of sand 🏖
        </div>
        <button class="border rounded p-2 m-5 bg-green-400 text-white w-1/4" type="submit">
          Get a quote
        </button>
        <div :if={@price} class="quote">
          Get your personal beach today for only <%= number_to_currency(@price) %>
        </div>
      </form>
    </div>
    """
  end
end
