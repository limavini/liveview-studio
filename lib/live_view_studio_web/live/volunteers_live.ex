defmodule LiveViewStudioWeb.VolunteersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Volunteers
  alias LiveViewStudio.Volunteers.Volunteer

  def mount(_params, _session, socket) do
    volunteers = Volunteers.list_volunteers()
    changeset = Volunteers.change_volunteer(%Volunteer{})

    socket =
      assign(socket,
        volunteers: volunteers,
        form: to_form(changeset)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-4xl">Volunteer Check-In</h1>

    <pre>

    <%!-- <%= inspect(@form, pretty: true)%> --%>
    </pre>

    <div class="">
      <.form for={@form} phx-submit="save">
        <.input field={@form[:name]} placeholder="Name" autocomplete="off" />
        <.input field={@form[:phone]} placeholder="Phone" type="tel" />

        <.button phx-disable-with="Saving...">Submit</.button>
      </.form>
    </div>

    <table class="table-auto">
      <thead>
        <tr>
          <th>Name</th>
          <th>Phone</th>
        </tr>
      </thead>
      <tbody>
        <tr :for={volunteer <- @volunteers}>
          <td><%= volunteer.name %></td>
          <td><%= volunteer.phone %></td>
        </tr>
      </tbody>
    </table>
    """
  end

  def handle_event("save", %{"volunteer" => volunteer_params}, socket) do
    case Volunteers.create_volunteer(volunteer_params) do
      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}

      {:ok, volunteer} ->
        socket = update(socket, :volunteers, fn volunteers -> [volunteer | volunteers] end)
        changeset = Volunteers.change_volunteer(%Volunteer{})
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
