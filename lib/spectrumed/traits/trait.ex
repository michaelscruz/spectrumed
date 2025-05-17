defmodule Spectrumed.Traits.Trait do
  use Ecto.Schema
  import Ecto.Changeset

  schema "traits" do
    field :description, :string
    field :bullets, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(trait, attrs) do
    trait
    |> cast(attrs, [:description])
    |> cast(attrs, [:bullets], empty_values: [])
    |> validate_required([:description])
  end
end
