defmodule SpectrumedWeb.TraitLive.Form do
  use SpectrumedWeb, :live_view

  alias Spectrumed.Traits
  alias Spectrumed.Traits.Trait

  @impl true
  def render(assigns) do
    IO.inspect(Ecto.Changeset.get_field(assigns.form.source, :bullets, []))

    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage trait records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="trait-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:description]} type="textarea" label="Description" />
        <ul>
          <li :for={bullet <- @form[:bullets].value}>
            <.input name="trait[bullets][]" value={bullet} type="text" phx-debounce="500" />
          </li>
          <li>
            <.link phx-click={add_bullet_to(@form)}>
              Add Bullet +
            </.link>
          </li>
        </ul>
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Trait</.button>
          <.button navigate={return_path(@return_to, @trait)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    trait = Traits.get_trait!(id)

    socket
    |> assign(:page_title, "Edit Trait")
    |> assign(:trait, trait)
    |> assign(:form, to_form(Traits.change_trait(trait)))
  end

  defp apply_action(socket, :new, _params) do
    trait = %Trait{}

    socket
    |> assign(:page_title, "New Trait")
    |> assign(:trait, trait)
    |> assign(:form, to_form(Traits.change_trait(trait)))
  end

  defp add_bullet_to(form) do
    trait_params =
      form.params
      |> Map.put(:bullets, Ecto.Changeset.get_field(form.source, :bullets, []))

    JS.push(%JS{}, "add-bullet", value: %{trait: trait_params})
  end

  @impl true
  def handle_event("validate", %{"trait" => trait_params}, socket) do
    IO.inspect(trait_params)
    changeset = Traits.change_trait(socket.assigns.trait, trait_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"trait" => trait_params}, socket) do
    save_trait(socket, socket.assigns.live_action, trait_params)
  end

  def handle_event("add-bullet", %{"trait" => trait_params}, socket) do
    IO.inspect(trait_params)
    bullets = List.insert_at(trait_params["bullets"] || [], -1, "")
    trait_params = Map.put(trait_params, "bullets", bullets)
    changeset = Traits.change_trait(socket.assigns.trait, trait_params)
    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  defp save_trait(socket, :edit, trait_params) do
    case Traits.update_trait(socket.assigns.trait, trait_params) do
      {:ok, trait} ->
        {:noreply,
         socket
         |> put_flash(:info, "Trait updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, trait))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_trait(socket, :new, trait_params) do
    case Traits.create_trait(trait_params) do
      {:ok, trait} ->
        {:noreply,
         socket
         |> put_flash(:info, "Trait created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, trait))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _trait), do: ~p"/traits"
  defp return_path("show", trait), do: ~p"/traits/#{trait}"
end
