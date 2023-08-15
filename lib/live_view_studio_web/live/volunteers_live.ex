defmodule LiveViewStudioWeb.VolunteersLive do
  use LiveViewStudioWeb, :live_view
  # Live Components are stateful

  # Initial Render: mount -> update -> render
  # Re-render: when assigns change -> update -> render (by itself or the parent)

  alias LiveViewStudio.Volunteers
  alias LiveViewStudioWeb.VolunteerFormComponent

  def mount(_params, _session, socket) do
    volunteers = Volunteers.list_volunteers()

    socket =
      socket
      # Use stream instead of temporary assigns when you want to modify the data
      |> stream(:volunteers, volunteers)
      |> assign(:count, length(volunteers))

    {:ok, socket}
  end

  # Update is called when the assigns change. It does nothing here, it's just to show
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-4xl">Volunteer Check-In</h1>

    <div>
      <.live_component module={VolunteerFormComponent} id={:new} count={@count} />
      <%!-- <pre> --%>
      <%!-- Use it for debugging --%>
      <%!-- <%= inspect(@form, pretty: true)%> --%>
      <%!-- </pre> --%>
    </div>

    <table class="table-auto">
      <thead>
        <tr>
          <th>Name</th>
          <th>Phone</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody id="volunteers" phx-update="stream">
        <.volunteer
          :for={{dom_id, volunteer} <- @streams.volunteers}
          volunteer={volunteer}
          dom_id={dom_id}
        />
      </tbody>
    </table>
    """
  end

  def volunteer(assigns) do
    ~H"""
    <tr id={@dom_id} class="border">
      <td class={if @volunteer.checked_out, do: "text-red-500", else: "text-green-500"}>
        <%= @volunteer.name %>
      </td>
      <td><%= @volunteer.phone %></td>
      <td>
        <button class="border rounded p-1" phx-click="toggle-status" phx-value-id={@volunteer.id}>
          <%= if @volunteer.checked_out, do: "Check In", else: "Check Out" %>
        </button>
      </td>
    </tr>
    """
  end

  def handle_event("toggle-status", %{"id" => volunteer_id}, socket) do
    volunteer = Volunteers.get_volunteer!(volunteer_id)

    {:ok, volunteer} =
      Volunteers.update_volunteer(volunteer, %{checked_out: !volunteer.checked_out})

    # Since this volunteer already exists in the list, it updates instead of inserting
    socket = stream_insert(socket, :volunteers, volunteer)

    {:noreply, socket}
  end

  def handle_info({:volunteer_created, volunteer}, socket) do
    socket = update(socket, :count, &(&1 + 1))
    socket = stream_insert(socket, :volunteers, volunteer, at: 0)

    {:noreply, socket}
  end
end
