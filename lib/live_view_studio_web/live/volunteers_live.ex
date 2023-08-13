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

    <div class="flex flex-row">
      <.form for={@form}>
        <.input field={@form[:name]} placeholder="Name" autocomplete="off" />
        <.input field={@form[:phone]} placeholder="Phone" type="tel" />

        <.button>Submit</.button>
      </.form>
    </div>

    <div class="table"></div>
    """
  end
end
