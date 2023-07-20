defmodule LiveViewStudioWeb.CustomComponents do
  use Phoenix.Component

  # https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#module-global-attributes
  # Attribute that can be passed to the component
  # https://online.pragmaticstudio.com/courses/liveview-2ed-pro/steps/19
  attr :expires_in, :integer, default: 10

  # Inner content that can be passed to the component
  slot :legal, required: true
  slot :inner_block, required: true

  def promo(assigns) do
    ~H"""
    <div>
      <%= render_slot(@inner_block) %>
      <div>
        <%= render_slot(@legal) %>
      </div>

      <div>Expires in <%= @expires_in %> days</div>
    </div>
    """
  end
end
