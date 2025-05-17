defmodule SpectrumedWeb.TraitLive.Show do
  use SpectrumedWeb, :live_view

  alias Spectrumed.Traits

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Trait {@trait.id}
        <:subtitle>This is a trait record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/traits"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/traits/#{@trait}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit trait
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Description">{@trait.description}</:item>
        <:item title="Bullets">{@trait.bullets}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Trait")
     |> assign(:trait, Traits.get_trait!(id))}
  end
end
