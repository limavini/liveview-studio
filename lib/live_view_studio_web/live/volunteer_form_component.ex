defmodule LiveViewStudioWeb.VolunteerFormComponent do
  # Must have a render function
  # Must have one html tag as the root element
  use LiveViewStudioWeb, :live_component
  alias LiveViewStudio.Volunteers
  alias LiveViewStudio.Volunteers.Volunteer

  def mount(socket) do
    changeset = Volunteers.change_volunteer(%Volunteer{})

    {:ok, assign(socket, form: to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
    <div>
      Go for it! You will be volunteer #<%= @count + 1 %>!
      <%!-- We need to add @myself because otherwise the form events will be submitted to the parent live view. --%>
      <.form for={@form} phx-submit="save" phx-change="validate" phx-target={@myself}>
        <.input field={@form[:name]} placeholder="Name" autocomplete="off" phx-debounce="2000" />
        <.input field={@form[:phone]} placeholder="Phone" type="tel" phx-debounce="blur" />

        <.button phx-disable-with="Saving...">Submit</.button>
      </.form>
    </div>
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
        # Since the stream is in the parent, we cannot insert it from here.
        # Since the parent and children are in the same process, we can send a message using self()
        send(self(), {:volunteer_created, volunteer})
        changeset = Volunteers.change_volunteer(%Volunteer{})

        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
