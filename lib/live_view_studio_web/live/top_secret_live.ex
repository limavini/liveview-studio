defmodule LiveViewStudioWeb.TopSecretLive do
  use LiveViewStudioWeb, :live_view

  # Read more on https://online.pragmaticstudio.com/courses/liveview-2ed-pro/steps/42
  on_mount {LiveViewStudioWeb.UserAuth, :ensure_authenticated}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <div class="row">
        <div class="col-12">
          <h1>Top Secret</h1>
          <h2>Your Mission</h2>
          <h3>Spy #00<%= @current_user.id %></h3>
          <p>Only authorized users can see this page.</p>
        </div>
      </div>
    </div>
    """
  end
end
