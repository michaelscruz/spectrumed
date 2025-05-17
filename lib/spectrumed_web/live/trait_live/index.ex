defmodule SpectrumedWeb.TraitLive.Index do
  use SpectrumedWeb, :live_view

  alias Spectrumed.Traits

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Traits
        <:actions>
          <.button variant="primary" navigate={~p"/traits/new"}>
            <.icon name="hero-plus" /> New Trait
          </.button>
        </:actions>
      </.header>

      <.table
        id="traits"
        rows={@streams.traits}
        row_click={fn {_id, trait} -> JS.navigate(~p"/traits/#{trait}") end}
      >
        <:col :let={{_id, trait}} label="Description">{trait.description}</:col>
        <:col :let={{_id, trait}} label="Bullets">{trait.bullets}</:col>
        <:action :let={{_id, trait}}>
          <div class="sr-only">
            <.link navigate={~p"/traits/#{trait}"}>Show</.link>
          </div>
          <.link navigate={~p"/traits/#{trait}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, trait}}>
          <.link
            phx-click={JS.push("delete", value: %{id: trait.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Traits")
     |> stream(:traits, Traits.list_traits())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    trait = Traits.get_trait!(id)
    {:ok, _} = Traits.delete_trait(trait)

    {:noreply, stream_delete(socket, :traits, trait)}
  end
end
