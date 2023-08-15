defmodule LiveViewStudioWeb.VolunteersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Volunteers
  alias LiveViewStudio.Volunteers.Volunteer

  def mount(_params, _session, socket) do
    volunteers = Volunteers.list_volunteers()
    changeset = Volunteers.change_volunteer(%Volunteer{})

    socket =
      socket
      |> stream(:volunteers, volunteers)
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-4xl">Volunteer Check-In</h1>

    <div class="">
      <.form for={@form} phx-submit="save" phx-change="validate">
        <.input field={@form[:name]} placeholder="Name" autocomplete="off" phx-debounce="2000" />
        <.input field={@form[:phone]} placeholder="Phone" type="tel" phx-debounce="blur" />

        <.button phx-disable-with="Saving...">Submit</.button>
      </.form>
      <pre>

    <%!-- <%= inspect(@form, pretty: true)%> --%>
    </pre>
    </div>

    <table class="table-auto">
      <thead>
        <tr>
          <th>Name</th>
          <th>Phone</th>
        </tr>
      </thead>
      <tbody id="volunteers" phx-update="stream">
        <tr :for={{dom_id, volunteer} <- @streams.volunteers} id={dom_id}>
          <td><%= volunteer.name %></td>
          <td><%= volunteer.phone %></td>
        </tr>
      </tbody>
    </table>
    """
  end

  def handle_event("validate", %{"volunteer" => volunteer_params}, socket) do
    changeset =
      %Volunteer{}
      |> Volunteers.change_volunteer(volunteer_params)
      |> Map.put(:action, :validate)

    socket = update(socket, :form, fn _ -> to_form(changeset) end)

    {:noreply, socket}
  end

  def handle_event("save", %{"volunteer" => volunteer_params}, socket) do
    case Volunteers.create_volunteer(volunteer_params) do
      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}

      {:ok, volunteer} ->
        # socket = update(socket, :volunteers, fn volunteers -> [volunteer | volunteers] end)
        socket = stream_insert(socket, :volunteers, volunteer, at: 0)
        changeset = Volunteers.change_volunteer(%Volunteer{})
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
